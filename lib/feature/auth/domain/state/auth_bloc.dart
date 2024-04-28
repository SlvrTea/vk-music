
import 'dart:developer';

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/data/service/vk_auth_service.dart';
import '../../../../core/domain/models/user.dart';
import '../../../../core/domain/state/music_loader/music_loader_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VKAuthService auth = VKAuthService();
  final MusicLoaderCubit musicLoader;
  final BuildContext context;
  final userBox = Hive.box('userBox');
  AuthBloc({
    required this.musicLoader,
    required this.context
  }) : super(AuthInitial()) {
    on<AuthUserEvent>(_onAuthUserEvent);
    on<UserLogoutEvent>(_onUserLogoutEvent);
    on<LoadUserEvent>(_onLoadUserEvent);
    on<UserLoginCaptchaEvent>(_onCaptcha);
  }

  _onCaptcha(UserLoginCaptchaEvent event, Emitter emit) async {
    emit(UserLoadingState());
    try {
      late User user;
      final response = await auth.captchaAuth(queryParameters: event.query, capchaSId: event.captchaSid, captchaKey: event.captchaKey);
      user = User.fromJson(response);
      userBox.put('user', user);
      userBox.put('loopMode', 0);
      userBox.put('shuffle', false);
      emit(UserLoadedState(user: user));
      musicLoader.loadMusic();
    } on DioException catch(e) {
      if (e.response == null) {
        emit(AuthFailed(errorMessage: 'Нет интернет подключения'));
      }
      if (e.response!.data['redirect_uri'] != null) {
        log('Tfa requested by server');
        log('Redirecting user to tfa page. Redirect url: ${e.response!.data}');
        context.go(
          'redirect/${e.response!.data}',
          extra: e.requestOptions.queryParameters
        );
      } else {
        emit(AuthFailed(errorMessage: e.response!.data['error_description']));
      }
    }
  }

  _onAuthUserEvent(AuthUserEvent event, Emitter emit) async {
    emit(UserLoadingState());
    try {
      late User user;
      if (event.url == null) {
        final response = await auth.auth(
            login: event.login!,
            password: event.password!
        );
        user = User.fromJson(response);
      } else {
        user = User(
          accessToken: event.url!.split('access_token=').last.split('&').first,
          secret: event.url!.split('secret=').last,
          userId: event.url!.split('user_id=').last.split('&').first,
        );
      }
      userBox.put('user', user);
      emit(UserLoadedState(user: user));
      userBox.put('loopMode', LoopMode.off);
      userBox.put('shuffle', false);
      musicLoader.loadMusic();
    } on DioException catch(e) {
      if (e.response == null) {
        emit(AuthFailed(errorMessage: 'Нет интернет подключения'));
      }
      if (e.response!.data['error'] == 'need_captcha') {
        log('Captcha needed. Captcha seed: ${e.response!.data['captcha_sid']}. Captcha img url: ${e.response!.data['captcha_img']}');
        // TODO: исправить работу капчи
        // navigatorKey.currentState!.pushReplacement(
        //     MaterialPageRoute(builder: (_) => Capcha(
        //       capchaUrl: e.response!.data['captcha_img'],
        //       capchaSId: e.response!.data['captcha_sid'],
        //       query: e.requestOptions.queryParameters,
        //     )
        //   )
        // );
      }
      if (e.response!.data['redirect_uri'] != null) {
        log('Tfa requested by server');
        log('Redirecting user to tfa page. Redirect url: ${e.response!.data}');
        context.go(
            'redirect/${e.response!.data}',
            extra: e.requestOptions.queryParameters
        );
      } else {
        emit(AuthFailed(errorMessage: e.response!.data['error_description']));
      }
    }
  }

  _onUserLogoutEvent(UserLogoutEvent event, Emitter emit) {
    log('User logout');
    userBox.delete('user');
    emit(AuthInitial());
  }

  _onLoadUserEvent(LoadUserEvent event, Emitter emit) {
    User? user = userBox.get('user');
    log('Loading user: ${user.toString()}');
    if (user != null) {
      musicLoader.loadMusic();
      emit(UserLoadedState(user: user));
    }
  }
}
