import 'package:echochat/screens/tabs/conversation_tab.dart';
import 'package:echochat/screens/tabs/discover_tab.dart';
import 'package:echochat/screens/tabs/profile_tab.dart';
import 'package:echochat/screens/tabs/settings_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});

  final List<Widget> _tabs = const [
    ConversationTab(),
    DiscoverTab(),
    ProfileTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    final titles = ["EchoChat", "Discover", "Profile", "Settings"];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex.value]),
        actions: [
          if (currentIndex.value == 0)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                currentIndex.value = 1;
              },
            ),
        ],
      ),

      body: IndexedStack(
        index: currentIndex.value,
        children: _tabs,
      ),

      floatingActionButton: currentIndex.value == 0
          ? FloatingActionButton(
              onPressed: () {
                currentIndex.value = 1;
              },
              child: const Icon(Icons.add_comment),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex.value,
        onDestinationSelected: (value) {
          currentIndex.value = value;
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: "Chats"),
          NavigationDestination(icon: Icon(Icons.explore), label: "Discover"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}