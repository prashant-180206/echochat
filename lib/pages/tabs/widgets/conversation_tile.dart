import 'package:echochat/core/models/conversation.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationTile({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(conversation.lastMessageContent.isNotEmpty
            ? conversation.lastMessageContent[0].toUpperCase()
            : "?"),
      ),
      title: Text(conversation.lastMessageSenderId ?? "Unknown"),
      subtitle: Text(
        conversation.lastTime.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatTime(conversation.lastTime ?? conversation.createdAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${time.day}/${time.month}";
  }
}