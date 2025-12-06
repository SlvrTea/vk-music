import 'package:cookie_jar/cookie_jar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../models/user/user.dart';

// Kinda dont lika all of that, but i am scared to change anything without proper docs
class VKAuthService {
  VKAuthService() {
    _init();
  }

  final dio = Dio(BaseOptions(validateStatus: (status) => status == 200 || status == 302,))
    ..interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
        enabled: kDebugMode,
      ),
      CookieManager(CookieJar()),
    ]);

  late final AndroidDeviceInfo _info;

  Map<String, dynamic> get _headers => {
    'User-Agent':
        'VKAndroidApp/8.143-40891 (Android ${_info.version.release}; SDK ${_info.version.sdkInt}; ${_info.supportedAbis.first}; ${_info.model}; ru; 1440x2891)',
    'Accept': 'image/webp',
    'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
    'Cache-Control': 'no-cache',
    'Connection': 'Keep-Alive',
  };

  void _init() async {
    _info = await DeviceInfoPlugin().androidInfo;
  }

  Future<String> firstStepAuth() async {
    final tokenRes = await getAnonymToken();
    await registerDevice(tokenRes);

    return tokenRes;
  }

  Future<String> exchangeToken(String token, String prcl) async {
    final headers = _headers
      ..addAll({
        'cookie': prcl,
        'host': 'api.vk.com',
        'X-Screeen': 'feed_recent',
        'X-VK-Android-Client': 'new',
      });
    final res = await dio.post(
      'https://api.vk.com/oauth/auth_by_exchange_token',
      options: Options(headers: headers),
      data: {
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'exchange_token': token,
        'client_id': 2274003,
        'scope': 'all',
        'initiator': 'expired_token',
        'sak_version': 1.123,
        'gaid': 'bfcdfdcc-de3f-cfd7-171d-53b83108dc90',
        'https': 1,
        'api_id': 2274003,
        'lang': 'ru',
        'v': AppGlobalDependency.apiVersion,
      },
    );
    return res.headers.map['Location']
        .toString()
        .split('access_token=')
        .last
        .split('&')
        .first;
  }

  Future<String> checkOtp({
    required String token,
    required String sid,
    required String code,
  }) async {
    final headers = _headers;
    headers.addAll({"X-Screen": "auth", "X-VK-Android-Client": "new"});

    final res = await dio.post(
      'https://api.vk.com/method/ecosystem.checkOtp',
      options: Options(headers: _headers),
      data: {
        'sid': sid,
        'code': code,
        'verification_method': 'codegen',
        // i have no idea where this is came from
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'access_token': token,
        'https': 1,
        'api_id': 2274003,
        'lang': 'ru',
        'v': AppGlobalDependency.apiVersion,
      },
    );

    if (res.data.containsKey('error')) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return res.data['response']['sid'];
  }

  Future<User> secondStepAuth({
    required String sid,
    required String login,
    required String password,
    required String token,
    String? successToken,
  }) async {
    final headers = _headers;
    headers.addAll({"X-Screen": "auth_password", "X-VK-Android-Client": "new"});
    final oauthRes = await dio.post(
      'https://api.vk.com/oauth/token${successToken == null ? '' : '?success_token=$successToken'}',
      options: Options(headers: headers),
      data: {
        'libverify_support': 1,
        'scope': 'all',
        'sid': sid,
        'grant_type': 'phone_confirmation_sid',
        'password': password,
        'username': login,
        'anonymous_token': token,
        'client_secret': 'hHbZxrka2uZ6jB1inYsH',
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'device_trusted_hash_supported': 1,
        '2fa_supported': 1,
        'supported_ways': 'push,email',
        'sak_version': '1.123',
        'flow_type': 'tg_flow',
        'https': 1,
        'api_id': 2274003,
        'lang': 'ru',
        'v': AppGlobalDependency.apiVersion,
      },
    );

    if (oauthRes.data.containsKey('error')) {
      throw DioException(
        requestOptions: oauthRes.requestOptions,
        response: oauthRes,
        type: DioExceptionType.badResponse,
      );
    }

    final userId = oauthRes.data['user_id'];
    final tmpToken = oauthRes.data['access_token'];

    final res = await dio.post(
      'https://api.vk.com/method/auth.refreshToken',
      options: Options(headers: _headers),
      data: {
        'lang': 'ru',
        'access_token': tmpToken,
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'v': AppGlobalDependency.apiVersion,
      },
    );

    final accessToken = res.data['response']['token'];

    final exchangeTokenRes = await dio.post(
      'https://api.vk.com/method/execute.getUserInfo',
      options: Options(
        headers: _headers
          ..addAll({"X-Screen": "feed_recent", "X-VK-Android-Client": "new"}),
      ),
      data: {
        'func_v': 33,
        'needExchangeToken': 1,
        'access_token': accessToken,
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'v': AppGlobalDependency.apiVersion,
      },
    );

    return User(
      accessToken: accessToken,
      userId: userId.toString(),
      secret: 'hHbZxrka2uZ6jB1inYsH',
      exchangeToken: exchangeTokenRes.data['response']['exchange_token'],
    );
  }

  Future<(String, bool)> validateAccount(
    String token,
    String login, [
    String? successToken,
  ]) async {
    final headers = _headers;
    headers.addAll({
      "X-Screen": "auth_start_with_phone",
      "X-VK-Android-Client": "new",
    });
    final res = await dio.post(
      'https://api.vk.com/method/auth.validateAccount${successToken == null ? '' : '?success_token=$successToken'}',
      options: Options(headers: headers),
      data: {
        'access_token': token,
        'login': login,
        'gaid': '856f21ed-cc34-de05-d420-f1ef29d27584',
        'supported_ways':
            'push,email,sms,callreset,password,reserve_code,codegen,passkey',
        'force_password': 0,
        'sak_version': '1.123',
        'flow_type': 'auth_without_password',
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'https': 1,
        'api_id': 2274003,
        'lang': 'ru',
        'v': AppGlobalDependency.apiVersion,
      },
    );
    if (res.data.containsKey('error')) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return (
      res.data['response']['sid'] as String,
      res.data['response'].containsKey('next_step') as bool,
    );
  }

  Future<String> getAnonymToken() async {
    final headers = _headers;
    headers.addAll({"X-Screen": "nowhere", "X-VK-Android-Client": "new"});

    final res = await dio.post(
      'https://api.vk.com/oauth/get_anonym_token',
      options: Options(headers: headers),
      data: {
        'client_id': 2274003,
        'client_secret': 'hHbZxrka2uZ6jB1inYsH',
        'v': AppGlobalDependency.apiVersion,
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'api_id': 2274003,
        'https': 1,
        'lang': 'ru',
      },
    );

    if (res.data.containsKey('error')) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }

    return res.data['token'];
  }

  Future<void> registerDevice(String token) async {
    final headers = _headers;
    headers.addAll({
      "X-Screen": "auth_start_with_phone",
      "X-VK-Android-Client": "new",
    });

    final res = await dio.post(
      'https://api.vk.com/method/account.registerDevice',
      options: Options(headers: headers),
      data: {
        'device_id': '2519f2213e3cacf8:90b1afb4ed8485f17533ece9580c1',
        'system_version': '16',
        'token': 'none',
        'device_model': _info.model,
        'access_token': token,
        'app_version': 40891,
        'type': '4',
        'pushes_granted': 0,
        'push_provider': 'fcm',
        'has_google_services': 1,
        'companion_apps': 'vk_client',
        'app_id': 2274003,
        'https': 1,
        'api_id': 2274003,
        'lang': 'ru',
        'v': AppGlobalDependency.apiVersion,
      },
    );

    if (res.data.containsKey('error')) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
