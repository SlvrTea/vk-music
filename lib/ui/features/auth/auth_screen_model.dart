import 'package:elementary/elementary.dart';
import 'package:hive_ce/hive.dart';
import 'package:logger/logger.dart';

import '../../../data/models/user/user.dart';
import '../../../domain/auth/auth_repository.dart';

abstract interface class IAuthScreenModel extends ElementaryModel {
  final AuthRepository authRepository;

  final userBox = Hive.box<User>('user');

  IAuthScreenModel(this.authRepository);

  Future<void> cacheUser(User user);

  Future<String?> firstStepAuth();

  Future<(String, bool)> validateAccount(
    String token,
    String login, [
    String? successToken,
  ]);

  Future<String> checkOtp({
    required String token,
    required String sid,
    required String code,
  });

  Future<User> secondStepAuth({
    required String sid,
    required String login,
    required String password,
    required String token,
    String? successToken,
  });

  User? loadUser();

  void logout();
}

class AuthScreenModel extends IAuthScreenModel {
  AuthScreenModel(super.authService);

  final _logger = Logger();

  @override
  Future<void> cacheUser(User user) async {
    _logger.i('Write user to cache: $user');
    await userBox.put('user', user);
  }

  @override
  Future<String?> firstStepAuth() async {
    _logger.i('Auth via default method');
    return authRepository.firstStepAuth();
  }

  @override
  User? loadUser() {
    _logger.i('Attempting to load user from cache');
    final user = userBox.get('user');
    if (user != null) {
      return user;
    }
    return null;
  }

  @override
  void logout() => userBox.delete('user');

  @override
  Future<(String, bool)> validateAccount(
    String token,
    String login, [
    String? successToken,
  ]) async => authRepository.validateAccount(
    token: token,
    login: login,
    successToken: successToken,
  );

  @override
  Future<String> checkOtp({
    required String token,
    required String sid,
    required String code,
  }) async => authRepository.checkOtp(token: token, sid: sid, code: code);

  @override
  Future<User> secondStepAuth({
    required String sid,
    required String login,
    required String password,
    required String token,
    String? successToken,
  }) async {
    final res = await authRepository.secondStepAuth(
      sid: sid,
      login: login,
      password: password,
      token: token,
      successToken: successToken,
    );
    await cacheUser(res);
    return res;
  }
}
