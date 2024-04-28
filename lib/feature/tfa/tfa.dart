import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/feature/home_screen/presentation/home.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/domain/const.dart';
import '../auth/domain/state/auth_bloc.dart';

class Tfa extends StatefulWidget {
  const Tfa({super.key, required this.redirect, required this.query});

  final String redirect;
  final Map<String, dynamic> query;

  @override
  State<Tfa> createState() => _TfaState();
}

class _TfaState extends State<Tfa> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
          onUrlChange: (url) {
            if (url.url!.startsWith('https://oauth.vk.com/blank.html#success=1')) {
              final auth = BlocProvider.of<AuthBloc>(context);
              auth.add(AuthUserEvent(password: widget.query['password'], login: widget.query['login'], url: url.url));
              context.go('/audios');
              // navigatorKey.currentState!.push(
              //     MaterialPageRoute(builder: (_) => const HomeTab())
              // );
            }
          }
      ))
      ..loadRequest(Uri.parse(widget.redirect));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Двухфакторная аутентификация'),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
