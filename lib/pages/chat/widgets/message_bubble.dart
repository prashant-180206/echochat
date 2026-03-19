import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isMe = message.senderId == supabase.auth.currentUser?.id;

    final bubbleColor = isMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;

    final timeColor = isMe
        ? colorScheme.inversePrimary
        : colorScheme.secondary;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12.0),
        ),

        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: textTheme.bodyMedium?.copyWith(color: textColor),
            ),

            const SizedBox(height: 4.0),

            Text(
              formatTime(message.createdAt),
              style: textTheme.bodySmall?.copyWith(color: timeColor),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24 && now.day == time.day) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1 && now.day - time.day == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(time);
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
