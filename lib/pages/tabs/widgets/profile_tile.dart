import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/services/conversation_service.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final Profile currentProfile;
  const ProfileTile({super.key, required this.currentProfile});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(currentProfile.name.toUpperCase()),
      trailing: IconButton(
        onPressed: () {
          ConversationService.connectUser(currentProfile);
        },
        icon: Icon(Icons.add),
      ),
      leading: CircleAvatar(
        child: Text(
          currentProfile.name.toUpperCase().isNotEmpty
              ? currentProfile.name.toUpperCase()[0]
              : "",
        ),
      ),
      subtitle: Text(currentProfile.email),
    );
  }
}
