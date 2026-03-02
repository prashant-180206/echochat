import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/services/discover_service.dart';
import 'package:echochat/pages/tabs/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DiscoverTab extends HookWidget {
  DiscoverTab({super.key});
 final List<Profile> data = [];
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () async {
                  final res = await DiscoverService().fetchUsers(
                    controller.text,
                  );
                },
                icon: Icon(Icons.search_outlined),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          ...data.map((val) {
            return ProfileTile(currentProfile: val);
          }),
        ],
      ),
    );
  }
}
