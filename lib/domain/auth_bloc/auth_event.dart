part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthUserEvent extends AuthEvent {
  final String? login;
  final String? password;
  final String? url;
  final BuildContext? context;

  AuthUserEvent({
    this.login,
    this.password,
    this.url,
    this.context
  });
}

class UserLogoutEvent extends AuthEvent {}

class LoadUserEvent extends AuthEvent {}
