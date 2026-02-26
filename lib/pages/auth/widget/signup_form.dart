import 'package:flutter/material.dart';
import 'package:echochat/data/profile.dart';

class SignUpForm extends StatefulWidget {
  final Future<bool> Function(ProfileDataUpload data) onSignUp;

  const SignUpForm({super.key, required this.onSignUp});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  bool showPassword = false;
  String gender = "Male";

  InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
  );

  @override
  Widget build(BuildContext context) {
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
            obscureText: !showPassword,
            decoration: inputDecoration.copyWith(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
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
            decoration: inputDecoration.copyWith(
              labelText: "Bio",
            ),
          ),

          // Gender
          DropdownButtonFormField<String>(
            initialValue: gender,
            items: const [
              DropdownMenuItem(value: "Male", child: Text("Male")),
              DropdownMenuItem(value: "Female", child: Text("Female")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
            decoration: inputDecoration.copyWith(labelText: "Gender"),
          ),

          // Submit
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                bool result = await widget.onSignUp(
                  ProfileDataUpload(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    bio: bioController.text.trim(),
                    gender: gender,
                  ),
                );
                if (!context.mounted) return;
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account created successfully")),
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