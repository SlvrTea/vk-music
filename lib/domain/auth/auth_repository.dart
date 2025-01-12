import '../../data/models/user/user.dart';
import '../../data/provider/auth/auth_service.dart';

class AuthRepository {
  final VKAuthService _authService = VKAuthService();

  Future<User> auth(String login, String password) => _authService.auth(login: login, password: password);

  Future<Map> captchaAuth() => throw UnimplementedError();
}
