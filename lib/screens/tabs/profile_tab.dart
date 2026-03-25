import 'package:echochat/core/providers/profile_provider.dart';
import 'package:echochat/screens/edit/edit_profile_screen.dart';
import 'package:echochat/utils/widgets/profile_view_avatar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileTab extends HookConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileInstanceProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
      data: (profile) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  ProfileViewAvatar(
                    avatarUrl: profile.avatarUrl,
                    name: profile.name,
                    size: 160,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton.small(
                      shape: CircleBorder(
                        side: BorderSide.none,

                        // : BorderRadius.circular(8),
                      ),

                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        ),
                      },
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              profile.email,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // --- Details Section ---
            Card(
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _ProfileLink(
                    icon: Icons.person_outline,
                    label: "Gender",
                    value: profile.gender,
                  ),
                  const Divider(height: 1),
                  _ProfileLink(
                    icon: Icons.info_outline,
                    label: "Bio",
                    value: profile.bio,
                  ),
                  const Divider(height: 1),
                  _ProfileLink(
                    icon: Icons.calendar_today_outlined,
                    label: "Joined",
                    value:
                        profile.createdAt?.toLocal().toString().split(' ')[0] ??
                        "N/A",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileLink({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
