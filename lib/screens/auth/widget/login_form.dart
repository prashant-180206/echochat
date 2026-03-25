import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginForm extends HookWidget {
  final Function(String email, String password) onLogin;
  LoginForm({super.key, required this.onLogin});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
  );

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final showPassword = useState(false);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            decoration: inputDecoration.copyWith(
              labelText: "Email",
              prefixIcon: const Icon(Icons.email),
            ),
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              if (value.length < 5) {
                return "Email must be at least 5 characters";
              }
              if (!value.contains("@")) {
                return "Email must contain @";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: inputDecoration.copyWith(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  showPassword.value = !showPassword.value;
                },
                icon: Icon(
                  showPassword.value ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            controller: passwordController,
            obscureText: !showPassword.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onLogin(emailController.text, passwordController.text);
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
