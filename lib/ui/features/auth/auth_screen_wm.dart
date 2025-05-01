import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../../common/utils/router/app_router.dart';
import '../../../data/models/user/user.dart';
import 'auth_screen_model.dart';
import 'auth_screen_widget.dart';

abstract interface class IAuthScreenWidgetModel implements IWidgetModel {
  TextEditingController get loginController;

  TextEditingController get passwordController;

  EntityValueListenable<bool> get obscurePassword;

  EntityValueListenable<User> get user;

  Future<void> onLoginTap();

  void onChangeObscureTap();
}

AuthScreenWidgetModel defaultAuthScreenWidgetModelFactory(BuildContext context) =>
    AuthScreenWidgetModel(AuthScreenModel(context.global.authRepository));

class AuthScreenWidgetModel extends WidgetModel<AuthScreen, IAuthScreenModel> implements IAuthScreenWidgetModel {
  AuthScreenWidgetModel(super.model);

  final _loginController = TextEditingController();

  final _passwordController = TextEditingController();

  final _obscurePasswordEntity = EntityStateNotifier<bool>();

  final _userEntity = EntityStateNotifier<User>();

  @override
  TextEditingController get loginController => _loginController;

  @override
  TextEditingController get passwordController => _passwordController;

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
      final userResp = await model.authUser(_loginController.text, _passwordController.text);
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
      } else if (e.response!.data['error'] == 'need_captcha') {
        _showError('На данный момент капча не работает :(');
      } else if (e.response!.data['redirect_uri'] != null) {
        if (!context.mounted) return;

        final resp = await context.router.push<String>(
            TfaRoute(query: e.requestOptions.queryParameters, redirect: e.response!.data['redirect_uri']));

        final user = await model.authUser(_loginController.text, _passwordController.text, resp);

        _userEntity.content(user!);

        context.global.user = user;

        if (!context.mounted) return;
        context.router.push(const MainRoute());
      } else {
        _showError(e.response!.data['error_description']);
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
}
