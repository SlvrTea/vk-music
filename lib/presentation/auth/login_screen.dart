import 'package:flutter/material.dart';

import 'auth_button.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Авторизация', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _LoginWidget(controller: loginController),
            const SizedBox(height: 8),
            _PasswordWidget(controller: passwordController),
            const SizedBox(height: 8),
            AuthButton(
              login: loginController.text,
              password: passwordController.text,
            )
          ],
        ),
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  final TextEditingController controller;
  const _LoginWidget({super.key, required this.controller});

  @override
  State<_LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<_LoginWidget> {
  final TextEditingController loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: loginController,
      onChanged: (value) => setState(() {}),
      decoration: const InputDecoration(
          hintText: 'Логин'
      ).applyDefaults(_inputDecoration),
    );
  }
}


class _PasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordWidget({super.key, required this.controller});

  @override
  State<_PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<_PasswordWidget> {
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: obscurePassword,
      onChanged: (value) => setState(() {}),
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Пароль',
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            obscurePassword = !obscurePassword;
          }),
          icon: Icon(obscurePassword
              ? Icons.visibility_rounded
              : Icons.visibility_off),
        ),
      ).applyDefaults(_inputDecoration),
    );
  }
}

final _inputDecoration = InputDecorationTheme(
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
);