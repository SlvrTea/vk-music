import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../../common/utils/router/app_router.dart';
import '../../../data/models/user/user.dart';
import 'auth_screen_model.dart';
import 'auth_screen_widget.dart';

abstract interface class IAuthScreenWidgetModel implements IWidgetModel {
  TextEditingController get loginController;

  TextEditingController get passwordController;

  MaskTextInputFormatter get formatter;

  EntityValueListenable<bool> get obscurePassword;

  EntityValueListenable<User> get user;

  Future<void> onLoginTap();

  Future<void> altKateAuth();

  void onChangeObscureTap();
}

AuthScreenWidgetModel defaultAuthScreenWidgetModelFactory(BuildContext context) =>
    AuthScreenWidgetModel(AuthScreenModel(context.global.authRepository));

class AuthScreenWidgetModel extends WidgetModel<AuthScreen, IAuthScreenModel> implements IAuthScreenWidgetModel {
  AuthScreenWidgetModel(super.model);

  final _loginController = TextEditingController();

  final _passwordController = TextEditingController();

  final _loginFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  final _obscurePasswordEntity = EntityStateNotifier<bool>();

  final _userEntity = EntityStateNotifier<User>();

  @override
  TextEditingController get loginController => _loginController;

  @override
  TextEditingController get passwordController => _passwordController;

  @override
  MaskTextInputFormatter get formatter => _loginFormatter;

  @override
  EntityValueListenable<bool> get obscurePassword => _obscurePasswordEntity;

  @override
  EntityValueListenable<User> get user => _userEntity;

  @override
  void dispose() {
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  @override
  void initWidgetModel() {
    final cachedUser = model.loadUser();
    if (cachedUser != null) {
      context.global.user = cachedUser;
      _userEntity.content(cachedUser);
      context.router.replace(const MainRoute());
    }
    _obscurePasswordEntity.content(true);
    super.initWidgetModel();
  }

  @override
  Future<void> onLoginTap() async {
    _userEntity.loading();
    if (_loginController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    try {
      final userResp = await model.authUser(_loginFormatter.getUnmaskedText(), _passwordController.text);
      if (userResp == null) {
        return;
      }
      if (context.mounted) {
        context.global
          ..user = userResp
          ..audioRepository.updateUser(userResp);
      }
      _userEntity.content(userResp);
    } on DioException catch (e) {
      if (e.response == null) {
        _showError('Нет подключения к интернету');
      } else if (e.response!.data['error']['redirect_uri'] != null) {
        if (!context.mounted) return;
        _showTfaError();
      } else {
        _showError(e.response!.data['error_msg']);
      }
    }
  }

  @override
  Future<void> altKateAuth() async {
    final url = await context.router.push<String?>(const KateAuthRoute());
    if (url != null) {
      final user = User(
        accessToken: url.split('access_token=').last.split('&').first,
        secret: 'hHbZxrka2uZ6jB1inYsH',
        userId: url.split('user_id=').last.split('&').first,
      );
      model.cacheUser(user);
      AppGlobalDependency.isKateAuth = true;
      if (context.mounted) {
        context
          ..global.updateConfig(context.global.config.copyWith(isKateAuth: true))
          ..router.replace(const MainRoute());
      }
    }
  }

  @override
  void onChangeObscureTap() {
    final data = _obscurePasswordEntity.value.data ?? true;
    _obscurePasswordEntity.content(!data);
  }

  void _showError(String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText)));
  }

  void _showTfaError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Ошибка валидации'),
      action: SnackBarAction(
        label: 'Подробнее',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: const Text('Ошибка валидации'),
              content: const Text('В связи с изменениями в api вк, при запросе на прохождение капчи, '
                  'авторизация с доступом к аудио невозможна.\n'
                  'Это может быть вызвано:'
                  '   Слишком частыми запросами на авторизацию с Вашего устройства'
                  '   Включенным VPN'
                  '   В вк просто решили, что Ваши действия подозрительные\n'
                  'Попробуйте подождать несколько часов или используйте альтернативный метод авторизации.'),
              actions: [
                TextButton(
                  onPressed: context.maybePop,
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
