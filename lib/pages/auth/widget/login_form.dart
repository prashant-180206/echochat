import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;
  const LoginForm({super.key, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
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
            validator: (value){
              if(value == null || value.isEmpty){
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
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),

              ),
            ),
            controller: passwordController,
            obscureText: !showPassword,
            validator: (value) {
              if(value == null || value.isEmpty){
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
              setState(() {});
              if (_formKey.currentState!.validate()) {
                widget.onLogin(emailController.text, passwordController.text);
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
