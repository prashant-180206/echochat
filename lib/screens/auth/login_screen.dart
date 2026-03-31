import 'package:echochat/core/services/auth_service.dart';
import 'package:echochat/screens/auth/signup_screen.dart';
import 'package:echochat/screens/auth/widget/login_form.dart';
import 'package:echochat/screens/tab_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginForm(
                onLogin: (email, password) async {
                  try {
                    await AuthService.signIn(email, password);
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TabScreen(),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Unexpected error occurred ${e.toString()}",
                        ),
                      ),
                    );
                  }
                },
                onGoogleLogin: () async {
                  try {
                    final success = await AuthService.signInWithGoogle();
                    if (!success) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Google sign-in cancelled"),
                        ),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TabScreen(),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Google sign-in error: ${e.toString()}",
                        ),
                      ),
                    );
                  }
                },
              ),

              Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text("Sign up", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
