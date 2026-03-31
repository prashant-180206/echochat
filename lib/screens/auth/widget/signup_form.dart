import 'package:echochat/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpForm extends HookWidget {
  final Future<bool> Function(ProfileDataUpload data) onSignUp;

  SignUpForm({super.key, required this.onSignUp});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
  );

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final bioController = useTextEditingController();
    final gender = useState("Male");
    final showPassword = useState(false);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            "Sign Up",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Name
          TextFormField(
            controller: nameController,
            decoration: inputDecoration.copyWith(
              labelText: "Name",
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name is required";
              }
              if (value.length < 3) {
                return "Minimum 3 characters";
              }

              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: inputDecoration.copyWith(
              labelText: "Email",
              prefixIcon: const Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              if (!value.contains("@")) {
                return "Invalid email";
              }
              return null;
            },
          ),

          // Password
          TextFormField(
            controller: passwordController,
            obscureText: !showPassword.value,
            decoration: inputDecoration.copyWith(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword.value ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  showPassword.value = !showPassword.value;
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Minimum 6 characters";
              }
              return null;
            },
          ),

          // Bio
          TextFormField(
            controller: bioController,
            decoration: inputDecoration.copyWith(labelText: "Bio"),
          ),

          // Gender
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
            decoration: inputDecoration.copyWith(labelText: "Gender"),
          ),

          // Submit
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                bool result = await onSignUp(
                  ProfileDataUpload(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    bio: bioController.text.trim(),
                    gender: gender.value,
                  ),
                );
                if (!context.mounted) return;
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account created successfully"),
                    ),
                  );
                  // Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to create account")),
                  );
                }
              }
            },
            child: const Text("Create Account"),
          ),
        ],
      ),
    );
  }
}
