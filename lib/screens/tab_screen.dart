import 'package:echochat/core/providers/app_theme_provider.dart';
import 'package:echochat/screens/tabs/conversation_tab.dart';
import 'package:echochat/screens/tabs/discover_tab.dart';
import 'package:echochat/screens/tabs/profile_tab.dart';
import 'package:echochat/screens/tabs/settings_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});
  @override
  ConsumerState<TabScreen> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<TabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ConversationTab(),
    DiscoverTab(),
    ProfileTab(),
    SettingsTab(),
  ];
  
  @override
  Widget build(BuildContext context) {
    final thememode = ref.watch(appThemeProvider);
      final theme = ref.read(appThemeProvider.notifier);
  
    return Scaffold(
      appBar: AppBar(
        title: const Text("EchoChat"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => theme.toggleTheme(),
            icon:  Icon(thememode==ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
          )
        ],
      ),
      body: _tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
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
