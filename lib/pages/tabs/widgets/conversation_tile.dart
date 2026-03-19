import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/pages/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationTile({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    // Get the other user (not the current user)
    final currentUserId = supabase.auth.currentUser?.id;
    final otherMember = conversation.members.firstWhere(
      (member) => member.id != currentUserId,
      orElse: () => ConversationMember(id: 'unknown', name: 'Unknown User'),
    );
    final hasAvatar =
        otherMember.avatarUrl != null && otherMember.avatarUrl!.isNotEmpty;
    final doBold =
        conversation.unread > 0 &&
        conversation.lastMessageSenderId != currentUserId;

    return ListTile(
      onTap: () {
        // Navigate to chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversationId: conversation.id,
              otherUser: otherMember,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: hasAvatar
            ? NetworkImage(otherMember.avatarUrl!)
            : null,
        child: !hasAvatar
            ? Text(
                otherMember.name.isNotEmpty
                    ? otherMember.name[0].toUpperCase()
                    : '?',
            
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : null,
      ),
      title: Text(
        otherMember.name,
        style:  TextStyle(fontWeight: doBold? FontWeight.w600: FontWeight.w400),
      ),
      subtitle: Text(
        conversation.lastMessageContent,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: doBold ? Colors.black : Colors.grey[600],
          fontWeight: doBold
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.lastTime ?? conversation.createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: doBold
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          if (doBold) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                conversation.unread > 99 ? '99+' : '${conversation.unread}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    if (diff.inDays < 7) return "${diff.inDays}d";
    return "${time.day}/${time.month}";
  }
}
