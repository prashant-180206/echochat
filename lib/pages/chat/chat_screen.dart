import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/providers/message_provider.dart';
import 'package:echochat/pages/chat/widgets/message_bubble.dart';
import 'package:echochat/pages/chat/widgets/message_input.dart';
import 'package:echochat/pages/chat/widgets/message_skeleton.dart';
import 'package:echochat/pages/tabs/widgets/error_display.dart';
import 'package:flutter/material.dart';
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
    final messages = ref.watch(dynamicMessagesProvider(conversationId));
    final staticMessages = ref.watch(messageHistoryProvider(conversationId));

    return Scaffold(
      appBar: AppBar(title: Text(otherUser.name)), // Accessing otherUser name
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.when(
                data: (dynamicMsgs) => staticMessages.when(
                  data: (historyMsgs) {
                    final allMessages = [...dynamicMsgs.reversed, ...historyMsgs.reversed];
                    if (allMessages.isEmpty) {
                      return const Center(child: Text("No messages Yet"));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final message = allMessages[index];
                        return MessageBubble(message: message);
                      },
                    );
                  },
                  error: (e, s) => ErrorDisplay(error: e, stackTrace: s),
                  loading: () => ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        MessageSkeleton(isMe: index % 2 == 0),
                  ),
                ),
                // REMOVED: The Expanded widget that was here before
                loading: () => ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) =>
                      MessageSkeleton(isMe: index % 2 == 0),
                ),
                error: (e, st) =>
                    const Center(child: Text('Error loading messages')),
              ),
            ),

            // The Send Message Input (Stays at the bottom)
            MessageInput(conversationId: conversationId),
          ],
        ),
      ),
    );
  }
}
