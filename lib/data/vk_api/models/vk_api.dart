import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'song.dart';
import 'user.dart';

method(String method, String args) async {
  final User user = Hive.box('userBox').get('user');
  final deviceId = _getRandomString(16);
  const v = 5.95;

  String url =
      '/method/$method?v=$v&access_token=${user.accessToken}&device_id=$deviceId&$args';
  final hash = crypto.md5.convert(utf8.encode(url + user.secret));

  var response = await Dio().get('https://api.vk.com$url&sig=$hash',
      options: Options(headers: {
        "User-Agent":
          "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
        "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
      }
      ));

  return response.data();
}

String _getRandomString(int lenght) {
  const chars =
      'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
  return String.fromCharCodes(Iterable.generate(
      lenght, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}

class VKApi {
  final auth = _VKAuth();
  final music = _VKMusic();
}

class _VKAuth {
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

class _VKMusic {
  final userBox = Hive.box('userBox');

  Future<dynamic> getMusic({required String args}) async {
    final User user = userBox.get('user');
    final deviceId = _getRandomString(16);
    const v = 5.95;
    final url =
        '/method/audio.get?access_token=${user.accessToken}&device_id=$deviceId&v=$v&$args';
    final hash = crypto.md5.convert(utf8.encode(url + user.secret));
    var response = await Dio().get('https://api.vk.com$url&sig=$hash',
        options: Options(headers: {
          "User-Agent":
            "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }));
    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Song.fromMap(map: e))
          .toList();
    }
    return data;
  }
}
