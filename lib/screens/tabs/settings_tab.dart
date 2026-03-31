import 'package:echochat/core/providers/app_theme_provider.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeNotifier = ref.read(appThemeProvider.notifier);

    final user = supabase.auth.currentUser;
    final theme = ref.watch(appThemeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            Text(
              'Settings',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    user?.email?.substring(0, 1).toUpperCase() ?? "?",
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                ),
                title: Text(user?.email ?? "Unknown User"),
                subtitle: const Text("Logged in"),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: SwitchListTile(
                secondary: Icon(
                  Icons.dark_mode,
                  color: colorScheme.onSurfaceVariant,
                ),
                title: const Text('Dark Mode'),
                value: theme == ThemeMode.dark,
                onChanged: (value) {
                  ref.read(appThemeProvider.notifier).toggleTheme();
                },
              ),
            ),

            const Spacer(),

            Card(
              color: colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: colorScheme.onErrorContainer,
                ),
                title: Text(
                  'Logout',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await supabase.auth.signOut();

                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LandingScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
