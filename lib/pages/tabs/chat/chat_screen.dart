import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/providers/message_provider.dart';
import 'package:echochat/pages/tabs/chat/widgets/message_skeleton.dart';
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
      appBar: AppBar(title: Text('Chat Screen')),
      body: messages.when(
        data: (messages) {
          return staticMessages.when(
            data: (msghistory) {
              final allMessages = [...messages, ...msghistory];

              if (allMessages.isEmpty) {
                return Center(child: Text("No messages Yet"));
              }
              return ListView.builder(
                itemCount: allMessages.length,
                itemBuilder: (context, index) {
                  final message = allMessages[index];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.createdAt.toString()),
                  );
                },
              );
            },
            error: (e, s) => ErrorDisplay(error: e, stackTrace: s),
            loading: () => ListView.builder(
              itemBuilder: (context, index) =>
                  MessageSkeleton(isMe: index % 2 == 0),
              itemCount: 6,
            ),
          );
         
        },
        loading: () => ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) =>
              MessageSkeleton(isMe: index % 2 == 0),
        ),
        error: (e, st) => Center(child: Text('Error loading messages')),
      ),
    );

  }
}
