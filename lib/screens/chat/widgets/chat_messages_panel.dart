import 'dart:math';

import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/message_bubble.dart';
import 'package:echochat/screens/chat/widgets/message_skeleton.dart';
import 'package:echochat/screens/tabs/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMessagesPanel extends StatelessWidget {
  const ChatMessagesPanel({
    super.key,
    required this.dynamicMessages,
    required this.historyMessages,
    required this.scrollController,
    required this.onEditMessagePressed,
  });

  final AsyncValue<List<Message>> dynamicMessages;
  final AsyncValue<List<Message>> historyMessages;
  final ScrollController scrollController;
  final ValueChanged<Message> onEditMessagePressed;

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return dynamicMessages.when(
      data: (dynamicMsgs) => historyMessages.when(
        data: (historyMsgs) {
          final allMessages = [
            ...dynamicMsgs.reversed,
            ...historyMsgs.reversed,
          ];

          if (allMessages.isEmpty) {
            return const Center(child: Text('No messages Yet'));
          }

          return ListView.builder(
            controller: scrollController,
            reverse: true,
            itemCount: allMessages.length,
            itemBuilder: (context, index) {
              final message = allMessages[index];
              return MessageBubble(
                message: message,
                onMessageDeleted: (msgId) {
                  logger.d('Message with ID $msgId deleted');
                  allMessages.removeWhere((msg) => msg.id == msgId);
                },
                onEditMessagePressed: (_) {
                  logger.d('Edit pressed for message ID ${message.id}');
                  onEditMessagePressed(message);
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
      loading: () => ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => MessageSkeleton(
          isMe: index % 2 == 0,
          widthOffset: random.nextInt(100),
        ),
      ),
      error: (e, st) => const Center(child: Text('Error loading messages')),
    );
  }
}
