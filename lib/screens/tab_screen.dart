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
  
    return Scaffold(
      appBar: AppBar(
        title: const Text("EchoChat"),
        foregroundColor: Colors.white,
       
      ),
      body: _tabs[currentIndex.value],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        onTap: (value) {
          currentIndex.value = value;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        
      ),
    );
  }
}
