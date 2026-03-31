import 'dart:async';
import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/providers/message_provider.dart';
import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/chat_header.dart';
import 'package:echochat/screens/chat/widgets/chat_messages_panel.dart';
import 'package:echochat/screens/chat/widgets/message_input.dart';
import 'package:echochat/screens/chat/widgets/typing_indicator.dart';
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

      channel.onBroadcast(
        event: 'typing',
        callback: (payload) {
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
        },
      );

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
      appBar: ChatHeader(
        otherUser: otherUser,
        isOtherTyping: isOtherTyping.value,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatMessagesPanel(
                dynamicMessages: messages,
                historyMessages: staticMessages,
                scrollController: scrollcontroller,
                onEditMessagePressed: (Message message) {
                  editMsgContent.value = message.content;
                  editMsgId.value = message.id;
                  isEditingMessage.value = true;
                },
              ),
            ),

            TypingIndicator(
              isVisible: isOtherTyping.value,
              userName: otherUser.name,
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
