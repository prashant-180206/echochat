import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/utils/widgets/person_info_screen.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeader({
    super.key,
    required this.otherUser,
    required this.isOtherTyping,
  });

  final ConversationMember otherUser;
  final bool isOtherTyping;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonInfoScreen(userId: otherUser.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(otherUser.name),
            Text(
              isOtherTyping ? 'Typing...' : 'Last seen recently',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: otherUser.avatarUrl != ''
              ? Image.network(otherUser.avatarUrl)
              : Text(otherUser.name[0]),
        ),
      ),
    );
  }
}
