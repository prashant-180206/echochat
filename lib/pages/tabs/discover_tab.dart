import 'package:echochat/backend/discover_service.dart';
import 'package:echochat/data/profile.dart';
import 'package:echochat/pages/tabs/widgets/profile_tile.dart';
import 'package:flutter/material.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  List<Profile> data = [];

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () async {
                  final res = await DiscoverService().fetchUsers(
                    _controller.text,
                  );
                  setState(() {
                    data = res;
                  });
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
