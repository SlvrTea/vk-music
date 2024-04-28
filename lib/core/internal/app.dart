import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/core/router/router.dart';
import 'package:vk_music/core/styles/main_theme.dart';

import '../../feature/auth/domain/state/auth_bloc.dart';
import '../../feature/playlists_tab/domain/state/playlists_cubit.dart';
import '../../feature/search_tab/domain/state/search_cubit.dart';
import '../domain/models/music_player.dart';
import '../domain/state/music_loader/music_loader_cubit.dart';
import '../domain/state/music_player/music_player_cubit.dart';
import '../domain/state/music_progress/music_progress_cubit.dart';
import '../domain/state/nav_bar/nav_bar_cubit.dart';

final _router = GoRouter.routingConfig(
  routingConfig: routerConfig,
  initialLocation: '/'
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final navBar = NavBarCubit();
    final search = SearchCubit()..getRecommendations();
    final musicLoaderBloc = MusicLoaderCubit();
    final musicPlayerBloc = MusicPlayerCubit(musicPlayer: MusicPlayer());
    final musicProgress = MusicProgressCubit(musicPlayer: musicPlayerBloc.musicPlayer);
    final playlists = PlaylistsCubit();
    final authBloc = AuthBloc(musicLoader: musicLoaderBloc, context: context)
      ..add(LoadUserEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => authBloc
        ),
        BlocProvider<MusicLoaderCubit>(
            create: (context) => musicLoaderBloc
        ),
        BlocProvider<MusicPlayerCubit>(
            create: (context) => musicPlayerBloc
        ),
        BlocProvider<NavBarCubit>(
            create: (context) => navBar
        ),
        BlocProvider<PlaylistsCubit>(
            create: (_) => playlists
        ),
        BlocProvider<MusicProgressCubit>(
            create: (_) => musicProgress
        ),
        BlocProvider<SearchCubit>(
            create: (_) => search
        )
      ],
      child: MaterialApp.router(
        title: 'VK Music Player',
        scrollBehavior: const MaterialScrollBehavior()
            .copyWith(dragDevices: PointerDeviceKind.values.toSet(), physics: const BouncingScrollPhysics()),
        theme: MainTheme.themeData,
        routerConfig: _router,
      ),
    );
  }
}
