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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text('Авторизация VK', style: wm.wmTheme.h3)),
                const SizedBox(height: 16),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.activeField,
                  builder: (context, field) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment<String>(
                              value: 'phone',
                              label: Text('Номер Телефона'),
                            ),
                            ButtonSegment<String>(
                              value: 'email',
                              label: Text('Почта'),
                            ),
                          ],
                          selected: field!,
                          onSelectionChanged: (field) =>
                              wm.onChangeActiveField(field),
                        ),
                        const SizedBox(height: 16),
                        if (field.contains('phone'))
                          TextField(
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            controller: wm.phoneController,
                            inputFormatters: [wm.formatter],
                            decoration: const InputDecoration(
                              hintText: 'Номер Телефона',
                            ),
                          ),
                        if (field.contains('email'))
                          TextField(
                            autofillHints: const [AutofillHints.email],
                            controller: wm.emailComtroller,
                            inputFormatters: [wm.formatter],
                            decoration: const InputDecoration(
                              hintText: 'Почта',
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: wm.onLoginTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  child: const Text('Продолжить'),
                ),
                ElevatedButton(
                  onPressed: wm.altKateAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  child: const Text('Альтернативный метод'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
