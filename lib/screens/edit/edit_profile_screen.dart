import 'package:echochat/core/providers/profile_provider.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/edit/widgets/profile_update_form.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileInstanceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: profile.when(
          data: (data) => ProfileUpdateForm(
            initialProfile: data,
            onSuccess: () {
              logger.d("Profile updated, refreshing...");
            },
          ),
          error: (e, s) => ErrorWidget(e),
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
