import 'package:echochat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "EchoChat",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Center(child: Image.asset('assets/images/Logo.png')),
            Text(
              "Welcome to EchoChat! ",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Chat and Have Fun! ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}
