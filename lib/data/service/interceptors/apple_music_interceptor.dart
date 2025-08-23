import 'package:dio/dio.dart';

const _appleMusicApiKey =
    'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNzQ0ODMwNzIxLCJleHAiOjE3NTIwODgzMjEsInJvb3RfaHR0cHNfb3JpZ2luIjpbImFwcGxlLmNvbSJdfQ.cIz-EyZfbwgOzioztmbdpgrDwsaYJpDQqYvLP4K4dOF_0zKhCCRQHS_s6VmLJXEa9fxu8-0ScHkOAqxddCvG7Q';

class AppleMusicInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({'Origin': 'https://music.apple.com', 'Authorization': 'Bearer $_appleMusicApiKey'});

    options.queryParameters.addAll({
      'l': 'en-US',
      'limit': 1,
      'platform': 'web',
      'types': 'songs',
    });
    super.onRequest(options, handler);
  }
}
