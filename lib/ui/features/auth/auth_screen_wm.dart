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
  TextEditingController get phoneController;

  TextEditingController get emailComtroller;

  MaskTextInputFormatter get formatter;

  EntityValueListenable<User> get user;

  EntityValueListenable<Set<String>> get activeField;

  Future<void> onLoginTap();

  Future<void> altKateAuth();

  void onChangeObscureTap();

  void onChangeActiveField(Set<String> field);
}

AuthScreenWidgetModel defaultAuthScreenWidgetModelFactory(
  BuildContext context,
) => AuthScreenWidgetModel(AuthScreenModel(context.global.authRepository));

class AuthScreenWidgetModel extends WidgetModel<AuthScreen, IAuthScreenModel>
    implements IAuthScreenWidgetModel {
  AuthScreenWidgetModel(super.model);

  final _phoneController = TextEditingController();

  final _emailComtroller = TextEditingController();

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _obscurePasswordEntity = EntityStateNotifier<bool>();

  final _userEntity = EntityStateNotifier<User>();

  final _activeFieldEntity = EntityStateNotifier.value({'phone'});

  @override
  TextEditingController get phoneController => _phoneController;

  @override
  TextEditingController get emailComtroller => _emailComtroller;

  @override
  MaskTextInputFormatter get formatter => _phoneFormatter;

  @override
  EntityValueListenable<User> get user => _userEntity;

  @override
  EntityValueListenable<Set<String>> get activeField => _activeFieldEntity;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initWidgetModel() {
    final cachedUser = model.loadUser();
    if (cachedUser != null) {
      context.global.user = cachedUser;
      _userEntity.content(cachedUser);
      context.replaceRoute(const MainRoute());
    }
    _obscurePasswordEntity.content(true);
    super.initWidgetModel();
  }

  @override
  Future<void> onLoginTap() async {
    _userEntity.loading();
    if (_phoneController.text.isEmpty && _emailComtroller.text.isEmpty) {
      return;
    }

    final token = await model.firstStepAuth();

    try {
      final validateRes = await model.validateAccount(
        token!,
        _activeFieldEntity.value.data!.contains('phone')
            ? _phoneFormatter.getUnmaskedText()
            : _emailComtroller.text,
      );
      if (context.mounted && validateRes.$2) {
        context.pushRoute(
          TfaRoute(
            sid: validateRes.$1,
            token: token,
            onAcceptTap: (String code) =>
                model.checkOtp(token: token, sid: validateRes.$1, code: code),
          ),
        );
      }
      if (context.mounted && !validateRes.$2) {
        context.pushRoute(
          PasswordRoute(
            onConfirmTap: (String password) async =>
                _auth(password, sid: validateRes.$1, token: token),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response == null) {
        _showError('Нет подключения к интернету');
      } else if (e.response!.data['error']['redirect_uri'] != null) {
        if (!context.mounted) return;
        final successToken = await context.pushRoute<String>(
          CaptchaRoute(uri: e.response!.data['error']['redirect_uri']),
        );
        if (successToken != null) {
          final validateRes = await model.validateAccount(
            token!,
            _phoneFormatter.getUnmaskedText(),
            successToken,
          );
          if (context.mounted && validateRes.$2) {
            final res = await context.pushRoute<String?>(
              TfaRoute(
                sid: validateRes.$1,
                token: token,
                onAcceptTap: (String code) => model.checkOtp(
                  token: token,
                  sid: validateRes.$1,
                  code: code,
                ),
              ),
            );
            if (res != null && context.mounted) {
              context.pushRoute(
                PasswordRoute(
                  onConfirmTap: (String password) async =>
                      _auth(password, sid: res, token: token),
                ),
              );
            }
          }
          if (context.mounted && !validateRes.$2) {
            context.pushRoute(
              PasswordRoute(
                onConfirmTap: (String password) async =>
                    _auth(password, sid: validateRes.$1, token: token),
              ),
            );
          }
        }
      } else {
        _showError(e.response!.data['error']['error_msg']);
      }
    }
  }

  Future<void> _auth(
    String password, {
    required String sid,
    required String token,
  }) async {
    try {
      await model.secondStepAuth(
        sid: sid,
        login: _phoneFormatter.getUnmaskedText(),
        password: password,
        token: token,
      );
      if (context.mounted) context.replaceRoute(MainRoute());
    } on DioException catch (e) {
      if (e.response?.data['redirect_uri'] != null) {
        _onAuthCaptcha(e.response!.data['redirect_uri'], sid, token, password);
      }
    }
  }

  Future<void> _onAuthCaptcha(
    String redirectUri,
    String sid,
    String token,
    String password,
  ) async {
    try {
      if (!context.mounted) return;
      final successToken = await context.pushRoute<String>(
        CaptchaRoute(uri: redirectUri),
      );

      if (successToken != null) {
        await model.secondStepAuth(
          sid: sid,
          login: _phoneFormatter.getUnmaskedText(),
          password: password,
          token: token,
          successToken: successToken,
        );
        if (context.mounted) context.replaceRoute(MainRoute());
      }
    } on DioException catch (e) {
      if (e.response?.data['error'] == 'need_validation' && context.mounted) {
        final sid = e.response!.data['validation_sid'];
        final res = await context.pushRoute<String?>(
          TfaRoute(
            sid: sid,
            token: token,
            onAcceptTap: (String code) => _onAcceptTfaCode(code, token, sid),
          ),
        );
        if (res != null) {
          await _auth(password, sid: res, token: token);
        }
      }
    }
  }

  Future<String> _onAcceptTfaCode(String code, String token, String sid) =>
      model.checkOtp(token: token, sid: sid, code: code);

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
          ..global.audioRepository.updateUser(user)
          ..global.updateConfig(
            context.global.config.copyWith(isKateAuth: true),
          )
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorText)));
  }

  @override
  void onChangeActiveField(Set<String> field) =>
      _activeFieldEntity.content(field);
}
