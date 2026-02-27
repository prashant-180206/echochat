import 'package:echochat/backend/conversation_service.dart';
import 'package:echochat/data/profile.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatefulWidget {
  final Profile currentProfile;
  const ProfileTile({super.key, required this.currentProfile});
  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.currentProfile.name.toUpperCase()),
      trailing: IconButton(
        onPressed: () {
          ConversationService().connectUser(widget.currentProfile);
        },
        icon: Icon(Icons.add),
      ),
      leading: CircleAvatar(
        child: Text(widget.currentProfile.name.toUpperCase()[0]),
      ),
      subtitle: Text(widget.currentProfile.email),
    );
  }
}
