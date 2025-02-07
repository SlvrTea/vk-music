import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final navigatorGlobalKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigatorState {
    if (navigatorGlobalKey.currentState == null) {
      throw Exception("can't provide NavigatorState as it isn't created yet or already disposed");
    }
    return navigatorGlobalKey.currentState!;
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final global = context.watch<AppGlobalDependency>();
    return MaterialApp.router(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(physics: const BouncingScrollPhysics()),
      theme: global.theme.themeData,
      routerDelegate: global.router.delegate(),
      routeInformationParser: global.router.defaultRouteParser(),
    );
  }
}
