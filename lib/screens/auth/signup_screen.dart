import 'package:echochat/core/services/auth_service.dart';
import 'package:echochat/screens/auth/login_screen.dart';
import 'package:echochat/screens/auth/widget/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              SignUpForm(
                onSignUp: (data) async {
                  await AuthService.signUp(data);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                  return true;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
