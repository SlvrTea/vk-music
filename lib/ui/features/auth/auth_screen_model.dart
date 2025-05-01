import 'package:elementary/elementary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:just_audio/just_audio.dart';

import '../../../data/models/user/user.dart';
import '../../../domain/auth/auth_repository.dart';

abstract interface class IAuthScreenModel extends ElementaryModel {
  final AuthRepository authRepository;

  final userBox = Hive.box('userBox');

  IAuthScreenModel(this.authRepository);

  Future<User?> authUser(String login, String password, [String? url]);

  User? loadUser();

  void logout();
}

class AuthScreenModel extends IAuthScreenModel {
  AuthScreenModel(super.authService);

  final _logger = Logger();

  void _cacheUser(User user, {LoopMode loopMode = LoopMode.off, bool shuffle = false}) {
    _logger.i('Write user to cache');
    userBox.put('user', user);
    userBox.put('loopMode', loopMode.index);
    userBox.put('shuffle', shuffle);
  }

  @override
  Future<User?> authUser(String login, String password, [String? url]) async {
    _logger.i('Attempt to auth user');
    late User user;
    if (url == null) {
      final res = await authRepository.auth(login, password);
      user = res;
    } else {
      user = User(
          accessToken: url
              .split('access_token=')
              .last
              .split('&')
              .first,
          secret: url
              .split('secret=')
              .last,
          userId: url
              .split('user_id=')
              .last
              .split('&')
              .first
      );
    }
    _cacheUser(user);
    return user;
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
}