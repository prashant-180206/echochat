import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/landing_screen.dart';
import 'package:echochat/screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// AuthGate handles navigation between authenticated and unauthenticated states
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Check if user is logged in
        final session = supabase.auth.currentSession;
        if (session != null) {
          return const TabScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
