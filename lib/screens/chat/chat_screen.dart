import 'dart:math';
import 'dart:async';
import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/providers/message_provider.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/message_bubble.dart';
import 'package:echochat/screens/chat/widgets/message_input.dart';
import 'package:echochat/screens/chat/widgets/message_skeleton.dart';
import 'package:echochat/utils/widgets/person_info_screen.dart';
import 'package:echochat/screens/tabs/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUser,
  });
  final int conversationId;
  final ConversationMember otherUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingMessage = useState(false);
    final editMsgContent = useState("");
    final editMsgId = useState(0);
    final isOtherTyping = useState(false);
    final typingDebouncer = useMemoized(() => Debouncer());
    final channelRef = useRef<RealtimeChannel?>(null);
    final typingHideTimerRef = useRef<Timer?>(null);
    final messages = ref.watch(dynamicMessagesProvider(conversationId));
    final random = useMemoized(() => Random());
    final staticMessages = ref.watch(messageHistoryProvider(conversationId));
    final currentUserId = supabase.auth.currentUser?.id;

    final scrollcontroller = useScrollController();

    void sendTypingState(bool isTyping) {
      final channel = channelRef.value;
      if (channel == null || currentUserId == null) return;

      channel.sendBroadcastMessage(
        event: 'typing',
        payload: {
          'conversation_id': conversationId,
          'sender_id': currentUserId,
          'is_typing': isTyping,
        },
      );
    }

    useEffect(() {
      void listener() {
        if (scrollcontroller.position.pixels >=
            scrollcontroller.position.maxScrollExtent - 200) {
          ref.read(messageHistoryProvider(conversationId).notifier).loadMore();
        }
      }

      scrollcontroller.addListener(listener);
      return () => scrollcontroller.removeListener(listener);
    }, [scrollcontroller, conversationId]);

    useEffect(() {
      final channel = supabase.channel('chat-typing-$conversationId');
      channelRef.value = channel;

      channel.onBroadcast(event: 'typing', callback: (payload) {
        final senderId = payload['sender_id'] as String?;
        final isTyping = payload['is_typing'] == true;

        if (senderId == null || senderId == currentUserId) return;

        if (!isTyping) {
          typingHideTimerRef.value?.cancel();
          isOtherTyping.value = false;
          return;
        }

        isOtherTyping.value = true;
        typingHideTimerRef.value?.cancel();
        typingHideTimerRef.value = Timer(const Duration(seconds: 2), () {
          isOtherTyping.value = false;
        });
      });

      channel.subscribe();

      return () {
        sendTypingState(false);
        typingHideTimerRef.value?.cancel();
        channel.unsubscribe();
        supabase.removeChannel(channel);
        channelRef.value = null;
      };
    }, [conversationId, currentUserId]);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonInfoScreen(userId: otherUser.id),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(otherUser.name), // Accessing otherUser name
              Text(
                isOtherTyping.value ? "Typing..." : "Last seen recently",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: otherUser.avatarUrl != ""
                ? Image.network(otherUser.avatarUrl)
                : Text(otherUser.name[0]),
          ),
        ), // Displaying the first letter of the name if no avatar
      ), // Accessing otherUser name
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.when(
                data: (dynamicMsgs) => staticMessages.when(
                  data: (historyMsgs) {
                    final allMessages = [
                      ...dynamicMsgs.reversed,
                      ...historyMsgs.reversed,
                    ];
                    if (allMessages.isEmpty) {
                      return const Center(child: Text("No messages Yet"));
                    }
                    return ListView.builder(
                      controller: scrollcontroller,
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final message = allMessages[index];
                        return MessageBubble(
                          message: message,
                          onMessageDeleted: (msgId) {
                            logger.d("Message with ID $msgId deleted");
                            allMessages.removeWhere((msg) => msg.id == msgId);
                          },
                          onEditMessagePressed: (msgId) {
                            logger.d("Edit pressed for message ID $msgId");
                            editMsgContent.value = message.content;
                            editMsgId.value = message.id;
                            isEditingMessage.value = true;
                          },
                        );
                      },
                    );
                  },
                  error: (e, s) => ErrorDisplay(error: e, stackTrace: s),
                  loading: () => ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => MessageSkeleton(
                      isMe: index % 2 == 0,
                      widthOffset: random.nextInt(100),
                    ),
                  ),
                ),
                // REMOVED: The Expanded widget that was here before
                loading: () => ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => MessageSkeleton(
                    isMe: index % 2 == 0,
                    widthOffset: random.nextInt(100),
                  ),
                ),
                error: (e, st) =>
                    const Center(child: Text('Error loading messages')),
              ),
            ),

            // The Send Message Input (Stays at the bottom)
            if (isOtherTyping.value)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${otherUser.name} is typing...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            isEditingMessage.value
                ? MessageEditInput(
                    initialText: editMsgContent.value,
                    onEditCompleted: (msg) {
                      MessageService.editTextMessage(editMsgId.value, msg);
                      isEditingMessage.value = false;
                    },
                    onEditCancel: () {
                      isEditingMessage.value = false;
                      editMsgContent.value = "";
                      editMsgId.value = 0;
                    },
                  )
                : MessageInput(
                    onSendPressed: (text) {
                      if (text.isEmpty) return;
                      logger.d("Send button pressed with message: $text");
                      MessageService.sendMessage(
                        conversationId: conversationId,
                        content: text,
                      );
                    },
                    onImageSendPressed: () {
                      logger.d("Send Image button pressed ");
                      MessageService.sendImageMessage(
                        conversationId: conversationId,
                      );
                    },
                    onTextChanged: (value) {
                      if (value.trim().isEmpty) {
                        sendTypingState(false);
                        return;
                      }

                      sendTypingState(true);
                      typingDebouncer.debounce(
                        duration: const Duration(milliseconds: 700),
                        onDebounce: () => sendTypingState(false),
                      );
                    },
                    onTypingStopped: () => sendTypingState(false),
                  ),
          ],
        ),
      ),
    );
  }
}
