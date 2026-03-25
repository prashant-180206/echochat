import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/landing_screen.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    void showComingSoon() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Coming soon!'),
          backgroundColor: colorScheme.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 24,

        children: [
          const SizedBox(height: 16),

          Text(
            'Settings',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Notifications'),
                  subtitle: const Text('Manage notification settings'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: showComingSoon,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Privacy'),
                  subtitle: const Text('Manage privacy settings'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: showComingSoon,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.storage,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Storage'),
                  subtitle: const Text('Manage app storage'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: showComingSoon,
                ),
              ],
            ),
          ),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.help,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Help & Support'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: showComingSoon,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('About'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'EchoChat',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 EchoChat',
                      children: const [
                        SizedBox(height: 16),
                        Text('A modern chat application built with Flutter.'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          Card(
            color: colorScheme.errorContainer,
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.onErrorContainer),
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
                      MaterialPageRoute(builder: (_) => const LandingScreen()),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
