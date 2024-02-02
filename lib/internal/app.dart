import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/data/vk_api/models/vk_api.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/models/music_player.dart';
import 'package:vk_music/domain/music_loader/music_loader_cubit.dart';
import 'package:vk_music/domain/state/music_progress/music_progress_cubit.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';

import '../domain/state/auth/auth_bloc.dart';
import '../domain/state/music_player/music_player_cubit.dart';
import '../domain/state/playlist/playlist_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final VKApi vkApi = VKApi();
    final navBar = NavBarCubit();
    final search = SearchCubit(vkApi);
    final musicLoaderBloc = MusicLoaderCubit(vkApi);
    final musicPlayerBloc = MusicPlayerCubit(musicPlayer: MusicPlayer(), vkApi: vkApi);
    final musicProgress = MusicProgressCubit(musicPlayer: musicPlayerBloc.musicPlayer);
    final playlists = PlaylistsCubit(vkApi);
    final playlist = PlaylistCubit(vkApi);
    final authBloc = AuthBloc(vkApi: vkApi, musicLoader: musicLoaderBloc)
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
        BlocProvider(
            create: (_) => playlists
        ),
        BlocProvider(
          create: (_) => playlist
        ),
        BlocProvider(
          create: (_) => musicProgress
        ),
        BlocProvider(
          create: (_) => search
        )
      ],
      child: MaterialApp(
        title: 'VK Music Player',
        navigatorKey: navigatorKey,
        scrollBehavior: const MaterialScrollBehavior()
            .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black
          ),
          colorScheme: ColorScheme.fromSeed(
            background: Colors.black,
            seedColor: Colors.redAccent,
            brightness: Brightness.dark,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.black
          )
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
