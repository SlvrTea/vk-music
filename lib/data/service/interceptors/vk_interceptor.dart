import 'dart:convert';
import 'dart:math' hide log;

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/user/user.dart';

class VKInterceptor extends Interceptor {
  VKInterceptor({required this.apiVersion, this.user});

  final double apiVersion;
  final User? user;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final deviceId = _getRandomString(16);

    final url = '/method/${options.path}?v=$apiVersion&access_token=${user?.accessToken}&device_id=$deviceId&'
        '${options.uri.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    final hash = crypto.md5.convert(utf8.encode(url + (user?.secret ?? '')));

    if (AppGlobalDependency.isKateAuth ?? false) {
      options.headers.addAll({
        "User-Agent": "KateMobileAndroid/109.1 lite-550 (Android 13; SDK 33; x86_64; Google Pixel 5; ru)",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept-Encoding": "gzip",
        "Content-Encoding": "gzip",
      });
    } else {
      options.headers.addAll({
        "User-Agent": "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
        "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
      });
    }
    final query = options.queryParameters;
    options.queryParameters = <String, dynamic>{
      'v': apiVersion,
      'access_token': user?.accessToken,
      if (AppGlobalDependency.isKateAuth ?? false) 'device_id': deviceId,
      if (AppGlobalDependency.isKateAuth ?? false) 'sig': hash,
    };
    options.queryParameters.addAll(query);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data['response'] is Map || response.data['response'] is List) {
      response.data = response.data['response'];
    }
    return handler.next(response);
  }

  String _getRandomString(int length) {
    const chars = 'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }
}
