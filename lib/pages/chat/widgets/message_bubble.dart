import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        message.senderId ==
        supabase
            .auth
            .currentUser
            ?.id; // Placeholder, replace with actual logic to determine if the message is from the current user
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.content, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4.0),
            Text(
              formatTime(message.createdAt),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
      // Example: Mon, Tue, Wed
      return DateFormat('EEE').format(time);
    } else {
      // Example: 19/03/2026
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
