import 'dart:async';
import 'dart:convert';
import 'dart:math' hide log;

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/user/user.dart';
import 'package:vk_music/domain/auth/auth_repository.dart';

class VKInterceptor extends Interceptor {
  VKInterceptor(
    this._authRepository, {
    required this.apiVersion,
    required this.updateUser,
    this.user,
  });

  final AuthRepository _authRepository;
  final double apiVersion;
  final void Function(User) updateUser;

  User? user;
  bool _exchangeInProcess = false;
  final _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final deviceId = _getRandomString(16);

    final url =
        '/method/${options.path}?v=$apiVersion&access_token=${user?.accessToken}&device_id=$deviceId&'
        '${options.uri.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    final hash = crypto.md5.convert(utf8.encode(url + (user?.secret ?? '')));

    if (AppGlobalDependency.isKateAuth ?? false) {
      options.headers.addAll({
        "User-Agent":
            "KateMobileAndroid/109.1 lite-550 (Android 13; SDK 33; x86_64; Google Pixel 5; ru)",
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
        "Accept-Encoding": "gzip",
        "Content-Encoding": "gzip",
      });
    } else {
      options.headers.addAll({
        "User-Agent":
            "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
        "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*",
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
      });
    }
    final query = options.queryParameters;
    options.queryParameters = <String, dynamic>{
      'v': apiVersion,
      'access_token': user?.accessToken,
      if (!(AppGlobalDependency.isKateAuth ?? false)) 'device_id': deviceId,
      if (!(AppGlobalDependency.isKateAuth ?? false)) 'sig': hash,
    };
    options.queryParameters.addAll(query);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data['response'] is Map || response.data['response'] is List) {
      response.data = response.data['response'];
    }

    // some shit code for handling expired token
    if (response.data['error']?['error_code'] == 1117 &&
        user != null &&
        !_exchangeInProcess) {
      _exchangeInProcess = true;
      Timer(const Duration(seconds: 5), () => _exchangeInProcess = false);
      final prcl = response.headers.map['set-cookie']!
          .firstWhere((e) => e.startsWith('prcl'))
          .split(';')
          .firstWhere((e) => e.startsWith('prcl'));

      final res = await _authRepository.exchangeToken(
        user!.exchangeToken,
        prcl,
      );

      user = user!.copyWith(accessToken: res);
      updateUser(user!);
      _exchangeInProcess = false;
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(err.response);
    return handler.next(err);
  }

  String _getRandomString(int length) {
    const chars =
        'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
      ),
    );
  }
}
