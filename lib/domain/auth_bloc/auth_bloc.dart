import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/data/vk_api/vk_music.dart';
import 'package:vk_music/presentation/tfa/tfa.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VKApi vkApi;
  AuthBloc({
    required this.vkApi
  }) : super(AuthInitial()) {
    on<AuthUserEvent>(_onAuthUserEvent);
    on<UserLogoutEvent>(_onUserLogoutEvent);
    on<LoadUserEvent>(_onLoadUserEvent);
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
    } on DioException catch(e) {
      if (e.response == null) {
        emit(AuthFailed(errorMessage: 'Нет интернет подключения'));
      }
      if (e.response!.data['redirect_uri'] != null) {
        Navigator.of(event.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => Tfa(redirect: e.response!.data))
        );
      } else {
        emit(AuthFailed(errorMessage: e.response!.data['error_description']));
      }
    }
  }
  _onUserLogoutEvent(UserLogoutEvent event, Emitter emit) {}
  _onLoadUserEvent(LoadUserEvent event, Emitter emit) {}
}
