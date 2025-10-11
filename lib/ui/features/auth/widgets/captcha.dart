// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@RoutePage()
class CaptchaScreen extends StatelessWidget {
  const CaptchaScreen({super.key, required this.uri});

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(uri)),
        initialSettings: InAppWebViewSettings(
          useShouldInterceptFetchRequest: true,
        ),
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          if (fetchRequest.url!.rawValue.startsWith(
            'https://api.vk.com/method/captchaNotRobot.check',
          )) {
            fetchRequest.action = FetchRequestAction.ABORT;
            final dio = Dio(BaseOptions(headers: fetchRequest.headers))
              ..interceptors.add(PrettyDioLogger(enabled: kDebugMode));
            final res = await dio.post(
              '${fetchRequest.url!.rawValue}&${fetchRequest.body}',
            );
            if (res.data['response']?['status'] == 'OK') {
              final sessionToken = (fetchRequest.body as String)
                  .split('&')
                  .firstWhere((String e) => e.startsWith('session_token'))
                  .replaceFirst('session_token=', '');
              await dio.post(
                'https://api.vk.com/method/captchaNotRobot.endSession?v=5.131',
                queryParameters: {
                  'session_token': sessionToken,
                  'domain': 'vk.com',
                  'access_token': null,
                },
              );
              if (context.mounted) {
                context.maybePop(res.data['response']['success_token']);
              }
            }
          }

          return fetchRequest;
        },
      ),
    );
  }
}
