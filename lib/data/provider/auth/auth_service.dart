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
    final res = await dio.post('https://oauth.vk.com/token',
        options: Options(headers: {
          "User-Agent":
              "VKAndroidApp/6.52-9185 (Android 12; SDK 31; x86_64; Google sdk_gphone64_x86_64; ru; 2952x1440)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }),
        queryParameters: {
          '2fa_supported': '1',
          'grant_type': 'password',
          'scope': 'audio',
          'client_id': 2274003,
          'client_secret': 'hHbZxrka2uZ6jB1inYsH',
          'v': '5.155',
          'libverify_support': '1',
          'force_sms': '1',
          'username': login,
          'password': password
        });
    if (res.data['error'] != null) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
      );
    }
    return User.fromJson(res.data);
  }
}
