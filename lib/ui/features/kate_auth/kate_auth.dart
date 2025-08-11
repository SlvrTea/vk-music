import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@RoutePage()
class KateAuthWidget extends StatelessWidget {
  const KateAuthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
            'https://oauth.vk.com/authorize?client_id=2685278&scope=65544&redirect_uri=https://oauth.vk.com/blank.html&display=page&response_type=token&revoke=1',
          ),
        ),
        onLoadStop: (controller, url) {
          if (url!.toString().startsWith('https://oauth.vk.com/blank.html#')) {
            context.router.maybePop<String>(url.toString());
          }
        },
      ),
    );
  }
}
