import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/services/conversation_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/chat_screen.dart';
import 'package:echochat/utils/widgets/profile_view_avatar.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationTile({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentUserId = supabase.auth.currentUser?.id;

    final otherMember = conversation.members.firstWhere(
      (member) => member.id != currentUserId,
      orElse: () => ConversationMember(id: 'unknown', name: 'Unknown User'),
    );

    final doBold =
        conversation.unread > 0 &&
        conversation.lastMessageSenderId != currentUserId;

    return ListTile(
      onTap: () {
        if (conversation.lastMessageSenderId !=supabase.auth.currentUser?.id) {
          // Mark as read
          ConversationService.markAsRead(conversation.id);
        }

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

      leading: ProfileViewAvatar(
        avatarUrl: otherMember.avatarUrl,
        name: otherMember.name,
      ),

      title: Text(
        otherMember.name,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: doBold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),

      subtitle: Text(
        conversation.lastMessageContent,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium?.copyWith(
          color: doBold ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          fontWeight: doBold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.lastTime ?? conversation.createdAt),
            style: textTheme.bodySmall?.copyWith(
              color: doBold
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),

          if (doBold) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                conversation.unread > 99 ? '99+' : '${conversation.unread}',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onPrimary,
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
