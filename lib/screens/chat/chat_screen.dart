import 'dart:math';
import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/providers/message_provider.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/message_bubble.dart';
import 'package:echochat/screens/chat/widgets/message_input.dart';
import 'package:echochat/screens/chat/widgets/message_skeleton.dart';
import 'package:echochat/screens/tabs/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final messages = ref.watch(dynamicMessagesProvider(conversationId));
    final random = useMemoized(() => Random());
    final staticMessages = ref.watch(messageHistoryProvider(conversationId));

    final scrollcontroller = useScrollController();

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

    return Scaffold(
      appBar: AppBar(title: Text(otherUser.name)), // Accessing otherUser name
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
            isEditingMessage.value
                ? MessageEditInput(
                    initialText: editMsgContent.value,
                    onEditCompleted: (msg) {
                      MessageService.editTextMessage(editMsgId.value, msg);
                    },
                    onEditCancel: () {
                      isEditingMessage.value = false;
                      editMsgContent.value = "";
                      editMsgId.value = 0;
                    },
                  )
                : MessageInput(
                    onSendPressed: (text) {
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
                  ),
          ],
        ),
      ),
    );
  }
}
