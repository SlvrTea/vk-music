
import 'package:auto_route/annotations.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';

import 'auth_screen_wm.dart';

@RoutePage()
class AuthScreen extends ElementaryWidget<IAuthScreenWidgetModel> {
  const AuthScreen({
    super.key
  }) : super(defaultAuthScreenWidgetModelFactory);

  @override
  Widget build(IAuthScreenWidgetModel wm) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Авторизация'),
            const SizedBox(height: 16),
            TextField(
              controller: wm.loginController,
              decoration: const InputDecoration(
                hintText: 'Логин'
              ),
            ),
            const SizedBox(height: 8),
            EntityStateNotifierBuilder(
              listenableEntityState: wm.obscurePassword,
              builder: (context, data) => TextField(
                controller: wm.passwordController,
                obscureText: data ?? true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  suffixIcon: IconButton(
                    onPressed: wm.onChangeObscureTap,
                    icon: data ?? true
                        ? const Icon(Icons.visibility_off_rounded)
                        : const Icon(Icons.visibility_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: wm.onLoginTap, child: const Text('Войти'))
          ],
        ),
      ),
    );
  }
}