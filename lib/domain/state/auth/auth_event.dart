part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthUserEvent extends AuthEvent {
  final String? login;
  final String? password;
  final String? url;
  //final BuildContext? context;

  AuthUserEvent({
    this.login,
    this.password,
    this.url,
    //this.context
  });
}

class UserLogoutEvent extends AuthEvent {}

class LoadUserEvent extends AuthEvent {}

class UserLoginCaptchaEvent extends AuthEvent {
  final Map<String, dynamic> query;
  final String captchaSid;
  final String captchaKey;

  UserLoginCaptchaEvent(this.query, {required this.captchaSid, required this.captchaKey});
}
