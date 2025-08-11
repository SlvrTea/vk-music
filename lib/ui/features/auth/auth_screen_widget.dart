import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';

import 'auth_screen_wm.dart';

@RoutePage()
class AuthScreen extends ElementaryWidget<AuthScreenWidgetModel> {
  const AuthScreen({super.key}) : super(defaultAuthScreenWidgetModelFactory);

  @override
  Widget build(AuthScreenWidgetModel wm) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Авторизация',
                style: wm.wmTheme.h3,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofillHints: const [AutofillHints.telephoneNumber],
                  controller: wm.loginController,
                  inputFormatters: [wm.formatter],
                  decoration: const InputDecoration(hintText: 'Логин'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EntityStateNotifierBuilder(
                  listenableEntityState: wm.obscurePassword,
                  builder: (context, data) => TextField(
                    controller: wm.passwordController,
                    obscureText: data ?? true,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.password],
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
              ),
              ElevatedButton(onPressed: wm.onLoginTap, child: const Text('Войти')),
              ElevatedButton(onPressed: wm.altKateAuth, child: const Text('Альтернативный метод'))
            ],
          ),
        ),
      ),
    );
  }
}
