import '../../data/models/user/user.dart';
import '../../data/provider/auth/auth_service.dart';

class AuthRepository {
  final VKAuthService _authService = VKAuthService();

  Future<String> firstStepAuth() => _authService.firstStepAuth();

  Future<(String, bool)> validateAccount({
    required String token,
    required String login,
    String? successToken,
  }) => _authService.validateAccount(token, login, successToken);

  Future<String> checkOtp({
    required String token,
    required String sid,
    required String code,
  }) => _authService.checkOtp(token: token, sid: sid, code: code);

  Future<User> secondStepAuth({
    required String sid,
    required String login,
    required String password,
    required String token,
    String? successToken,
  }) => _authService.secondStepAuth(
    sid: sid,
    login: login,
    password: password,
    token: token,
    successToken: successToken,
  );

  Future<String> exchangeToken(String token, String prcl) => _authService.exchangeToken(token, prcl);
}
