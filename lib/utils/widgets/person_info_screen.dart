import 'package:echochat/core/providers/profile_provider.dart';
import 'package:echochat/screens/person/widget/profile_info_skeleton.dart';
import 'package:echochat/utils/widgets/profile_view_avatar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonInfoScreen extends ConsumerWidget {
  final String userId;
  const PersonInfoScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileWithIdProvider(userId));
    return Scaffold(
      appBar: AppBar(title: Text("Profile Information")),
      body: profile.when(
        error: (e, st) => ErrorWidget(e),
        loading: () => PersonInfoSkeleton(),
        data: (profileData) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: ProfileViewAvatar(
                  avatarUrl: profileData.avatarUrl,
                  name: profileData.name,
                  size: 160,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profileData.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profileData.email,
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
                      value: profileData.gender,
                    ),
                    const Divider(height: 1),
                    _ProfileLink(
                      icon: Icons.info_outline,
                      label: "Bio",
                      value: profileData.bio,
                    ),
                    const Divider(height: 1),
                    _ProfileLink(
                      icon: Icons.calendar_today_outlined,
                      label: "Joined",
                      value:
                          profileData.createdAt?.toLocal().toString().split(
                            ' ',
                          )[0] ??
                          "N/A",
                    ),
                  ],
                ),
              ),
            ],
          ),
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
