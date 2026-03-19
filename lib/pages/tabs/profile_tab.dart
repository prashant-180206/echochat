import 'package:echochat/core/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileTab extends HookConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileInstanceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: profile.when(
        data: (p) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,

          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: p.avatarUrl.isNotEmpty
                  ? NetworkImage(p.avatarUrl)
                  : null,
              child: p.avatarUrl.isEmpty
                  ? Text(
                      p.name[0],
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
                  
            ),

            Text(
              textAlign: TextAlign.center,
              p.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
            ),

            Text(
              p.id,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            ListTile(leading: const Icon(Icons.email), title: Text(p.email)),

            Text(
              p.bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              p.gender,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              p.createdAt != null ? p.createdAt!.toUtc().toString() : "N/A",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              p.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, st) => const Center(child: Text("Error loading profile")),
      ),
    );
  }
}
