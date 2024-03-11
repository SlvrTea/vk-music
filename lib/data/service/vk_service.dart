
import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/user.dart';

abstract class VKService {
  final dio = Dio();
  Future<Response<dynamic>> method(String method, String args) async {
    final User user = Hive.box('userBox').get('user');
    final deviceId = _getRandomString(16);
    const v = 5.95;

    String url =
        '/method/$method?v=$v&access_token=${user.accessToken}&device_id=$deviceId&$args';
    final hash = crypto.md5.convert(utf8.encode(url + user.secret));

    var response = await dio.get('https://api.vk.com$url&sig=$hash',
        options: Options(headers: {
          "User-Agent":
          "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }
      ));
    return response;
  }
}

String _getRandomString(int length) {
  const chars =
      'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(math.Random().nextInt(chars.length))));
}