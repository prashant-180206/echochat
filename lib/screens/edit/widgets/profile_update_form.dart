import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/providers/profile_provider.dart'; // Import your provider
import 'package:echochat/core/singleton.dart';
import 'package:echochat/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileUpdateForm extends HookConsumerWidget {
  final Profile initialProfile;
  final VoidCallback? onSuccess;

  const ProfileUpdateForm({
    super.key,
    required this.initialProfile,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: initialProfile.name);
    final bioController = useTextEditingController(text: initialProfile.bio);
    final avatarUrl = useState(initialProfile.avatarUrl);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final gender = useState(initialProfile.gender);
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  backgroundImage: avatarUrl.value.isNotEmpty
                      ? NetworkImage(avatarUrl.value)
                      : null,
                  child: avatarUrl.value.isEmpty
                      ? Text(
                          initialProfile.name[0],
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton.small(
                    shape: CircleBorder(
                      side: BorderSide.none,

                      // : BorderRadius.circular(8),
                    ),

                    onPressed: () async {
                      final str =
                          await FileUtils.uploadProfileAvatarAndGetLink();
                      avatarUrl.value = str;

                      logger.d("Uploaded file URL: $str");
                    },
                    child: const Icon(Icons.edit, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // --- Name Field ---
          TextFormField(
            controller: nameController,
            decoration: decoration("Full Name", Icons.person_outline),
            validator: (v) =>
                (v == null || v.length < 2) ? "Enter a valid name" : null,
          ),

          TextFormField(
            controller: bioController,
            maxLines: 3,
            minLines: 1,
            decoration: decoration("Bio", Icons.article_outlined),
            validator: (v) =>
                (v == null || v.length < 6) ? "Bio too short" : null,
          ),

          DropdownButtonFormField<String>(
            initialValue: gender.value,
            items: const [
              DropdownMenuItem(value: "Male", child: Text("Male")),
              DropdownMenuItem(value: "Female", child: Text("Female")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (value) {
              gender.value = value!;
            },
            decoration: decoration("gender", Icons.wc),
          ),


          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final updatedProfile = initialProfile.copyWith(
                  name: nameController.text.trim(),
                  bio: bioController.text.trim(),
                  avatarUrl: avatarUrl.value.trim(),
                  gender: gender.value.trim(),
                );
                await ref
                    .read(profileInstanceProvider.notifier)
                    .updateProfile(updatedProfile);
                if (context.mounted) onSuccess?.call();
              }
            },
            child: const Text(
              "Update Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration decoration(String label, IconData icon) => InputDecoration(
    hintText: label,
    labelText: "",
    prefixIcon: Icon(icon),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
  );
}
