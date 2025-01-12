import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/common/utils/audio_player/audio_player_controller.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';
import 'package:vk_music/domain/state/music_progress/music_progress_cubit.dart';

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
  ThemeData? _theme;

  @override
  void initState() {
    context.global.addListener(() {
      setState(() {
        _theme = context.global.theme.themeData;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayerController();
    final global = context.global;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MusicPlayerCubit(musicPlayer: player),
        ),
        BlocProvider(
          create: (_) => MusicProgressCubit(musicPlayer: player),
        ),
      ],
      child: MaterialApp.router(
        scrollBehavior: ScrollConfiguration.of(context).copyWith(physics: const BouncingScrollPhysics()),
        theme: _theme ?? global.theme.themeData,
        routerDelegate: global.router.delegate(),
        routeInformationParser: global.router.defaultRouteParser(),
      ),
    );
  }
}
