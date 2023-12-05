import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../domain/auth_bloc/auth_bloc.dart';

class Tfa extends StatefulWidget {
  final String redirect;
  const Tfa({super.key, required this.redirect});

  @override
  State<Tfa> createState() => _TfaState();
}

class _TfaState extends State<Tfa> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    // return SafeArea(
    //   child: WebViewWidget(
    //     controller: WebViewController(),
    //     navigationDelegate: (NavigationRequest request) async {
    //       if (request.url.startsWith('https://oauth.vk.com/blank.html')) {
    //         context.read<AuthBloc>().add(AuthUserEvent(url: request.url));
    //         Navigator.pop(context);
    //       }
    //       return NavigationDecision.navigate;
    //     },
    //     userAgent:
    //     'VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)',
    //     initialUrl: widget.redirect,
    //   ),
    // );
  }
}
