
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@RoutePage()
class TfaScreen extends StatelessWidget {
  TfaScreen({
    super.key,
    required this.query,
    required this.redirect
  });

  final String redirect;
  final Map<String, dynamic> query;
  
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Двухфакторная аутентификация')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(redirect.toString(), forceToStringRawValue: true)),
        onWebViewCreated: (controller) => webViewController = controller,
        onLoadStop: (controller, url) {
          if (url!.toString().startsWith('https://oauth.vk.com/blank.html#success=1')) {
            context.router.maybePop<String>(url.toString());
          }
        },
      ),
    );
  }
}
