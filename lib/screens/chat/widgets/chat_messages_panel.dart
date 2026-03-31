import 'dart:math';

import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/message_bubble.dart';
import 'package:echochat/screens/chat/widgets/message_skeleton.dart';
import 'package:echochat/screens/tabs/widgets/error_display.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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
              final shouldShowDayHeader = _shouldShowDayHeader(
                allMessages: allMessages,
                index: index,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (shouldShowDayHeader)
                    _DayHeader(label: _buildDayLabel(message.createdAt)),
                  MessageBubble(
                    message: message,
                    onMessageDeleted: (msgId) {
                      logger.d('Message with ID $msgId deleted');
                      allMessages.removeWhere((msg) => msg.id == msgId);
                    },
                    onEditMessagePressed: (_) {
                      logger.d('Edit pressed for message ID ${message.id}');
                      onEditMessagePressed(message);
                    },
                  ),
                ],
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

  bool _shouldShowDayHeader({
    required List<Message> allMessages,
    required int index,
  }) {
    if (allMessages.isEmpty) return false;
    if (index == allMessages.length - 1) return true;

    final current = DateUtils.dateOnly(allMessages[index].createdAt.toLocal());
    final above = DateUtils.dateOnly(
      allMessages[index + 1].createdAt.toLocal(),
    );

    return current != above;
  }

  String _buildDayLabel(DateTime date) {
    final localDate = date.toLocal();
    final current = DateUtils.dateOnly(localDate);
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    if (current == today) return 'Today';
    if (current == yesterday) return 'Yesterday';
    return DateFormat('d MMMM y').format(localDate);
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: theme.textTheme.labelMedium),
        ),
      ),
    );
  }
}
