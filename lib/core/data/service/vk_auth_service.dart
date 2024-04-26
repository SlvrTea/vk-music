
import 'package:dio/dio.dart';

class VKAuthService {
  Future<Map> auth({required String login, required String password}) async {
    final dio = Dio();
    final authResponse = await dio.post('https://oauth.vk.com/token',
        options: Options(
            headers: {
              "User-Agent":
              "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
              "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
            }
        ),
        queryParameters: {
          '2fa_supported': '1',
          'grant_type': 'password',
          'scope': 'nohttps,audio',
          'client_id': 2274003,
          'client_secret':'hHbZxrka2uZ6jB1inYsH',
          'validate_token': 'true',
          'v': '5.95',
          'username': login,
          'password': password
        });

    return authResponse.data;
  }

  Future<Map> captchaAuth({required Map<String, dynamic> queryParameters, required String capchaSId, required String captchaKey}) async {
    final dio = Dio();
    queryParameters.addAll({'captcha_sid': capchaSId, 'captcha_key': captchaKey});
    final authResponse = await dio.post('https://oauth.vk.com/token',
        options: Options(
            headers: {
              "User-Agent": "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
              "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
            }
        ),
        queryParameters: queryParameters
    );
    return authResponse.data;
  }
}