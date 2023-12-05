import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'song.dart';
import 'user.dart';

class VKApi {
  final auth = _VKAuth();
}

class _VKAuth {
  Future<Map> auth({required String login, required String password}) async {
    final dio = Dio();
    final authResponse = await dio.post('https://oauth.vk.com/token',
      queryParameters: {
        '2fa_supported': '1',
        'grant_type': 'password',
        'scope': 'audio',
        'client_id': 2685278,
        'client_secret': 'lxhD8OD7dMsqtXIm5IUY',
        'username': login,
        'password': password
        // 'client_id': 51807929,
        // 'display': 'mobile',
        // 'redirect_uri': 'https://oauth.vk.com/blank.html',
        // 'scope': 'audio',
        // 'response_type': 'token'
      });
    return authResponse.data;
  }
}

class _VKMusic {
  Future<dynamic> getMusic({required String args, required User user}) async {
    final String deviceId = _getRandomString(16);
    const double v = 5.95;
    final String url = '/method/audio.get?v=$v&access_token=${user.accessToken}&device_id=$deviceId&$args';
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

  String _getRandomString(int lenght) {
    const chars =
        'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
    return String.fromCharCodes(Iterable.generate(
        lenght, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }
}
