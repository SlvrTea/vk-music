
import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/data/vk_api/vk_music.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/music_loader/music_loader_cubit.dart';
import 'package:vk_music/presentation/auth/captcha.dart';
import 'package:vk_music/presentation/tfa/tfa.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VKApi vkApi;
  final MusicLoaderCubit musicLoader;
  final userBox = Hive.box('userBox');
  AuthBloc({
    required this.vkApi,
    required this.musicLoader
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
      final response = await vkApi.auth.captchaAuth(queryParameters: event.query, capchaSId: event.captchaSid, captchaKey: event.captchaKey);
      user = User.fromJson(response);
      userBox.put('user', user);
      emit(UserLoadedState(user: user));
      musicLoader.loadMusic();
    } on DioException catch(e) {
      if (e.response == null) {
        emit(AuthFailed(errorMessage: 'Нет интернет подключения'));
      }
      if (e.response!.data['redirect_uri'] != null) {
        navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => Tfa(
              redirect: e.response!.data,
              query: e.requestOptions.queryParameters,
            ))
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
        final response = await vkApi.auth.auth(
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
      musicLoader.loadMusic();
    } on DioException catch(e) {
      if (e.response == null) {
        emit(AuthFailed(errorMessage: 'Нет интернет подключения'));
      }
      if (e.response!.data['error'] == 'need_captcha') {
        navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => Capcha(
              capchaUrl: e.response!.data['captcha_img'],
              capchaSId: e.response!.data['captcha_sid'],
              query: e.requestOptions.queryParameters,
            )
          )
        );
      }
      if (e.response!.data['redirect_uri'] != null) {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (_) => Tfa(
            redirect: e.response!.data['redirect_uri'],
            query: e.requestOptions.queryParameters,
          ))
        );
      } else {
        emit(AuthFailed(errorMessage: e.response!.data['error_description']));
      }
    }
  }
  _onUserLogoutEvent(UserLogoutEvent event, Emitter emit) {}
  _onLoadUserEvent(LoadUserEvent event, Emitter emit) {
    User? user = userBox.get('user');
    if (user != null) {
      musicLoader.loadMusic();
      emit(UserLoadedState(user: user));
    }
  }
}
