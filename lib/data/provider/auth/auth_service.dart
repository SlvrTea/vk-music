import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/user/user.dart';

class VKAuthService {
  final dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 120,
      enabled: kDebugMode,
    ));

  Future<User> auth({required String login, required String password}) async {
    final authResponse = await dio.post('https://oauth.vk.com/token',
        options: Options(headers: {
          "User-Agent": "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }),
        queryParameters: {
          '2fa_supported': '1',
          'grant_type': 'password',
          'scope': 'nohttps,audio',
          'client_id': 2274003,
          'client_secret': 'hHbZxrka2uZ6jB1inYsH',
          'validate_token': 'true',
          'v': '5.95',
          'username': login,
          'password': password
        });

    return User.fromJson(authResponse.data);
  }

  Future<Map> captchaAuth(
      {required Map<String, dynamic> queryParameters, required String capchaSId, required String captchaKey}) async {
    queryParameters.addAll({'captcha_sid': capchaSId, 'captcha_key': captchaKey});
    final authResponse = await dio.post('https://oauth.vk.com/token',
        options: Options(headers: {
          "User-Agent": "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }),
        queryParameters: queryParameters);
    return authResponse.data;
  }
}
