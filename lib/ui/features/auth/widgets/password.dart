import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

@RoutePage()
class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key, required this.onConfirmTap});

  final Future<void> Function(String) onConfirmTap;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  late final TextEditingController controller;

  bool obscure = true;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text('Введите пароль', style: context.global.theme.h3),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        obscure = !obscure;
                      }),
                      icon: obscure
                          ? Icon(Icons.visibility_off_rounded)
                          : Icon(Icons.visibility_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => widget.onConfirmTap(controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  child: Text('Продолжить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
