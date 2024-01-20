import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/data/vk_api/models/vk_api.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/music_loader/music_loader_cubit.dart';
import 'package:vk_music/domain/music_player.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';

import '../domain/state/auth/auth_bloc.dart';
import '../domain/state/music_player/music_player_bloc.dart';
import '../domain/state/playlist/playlist_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final VKApi vkApi = VKApi();
    final navBar = NavBarCubit();
    final musicLoaderBloc = MusicLoaderCubit(vkApi);
    final musicPlayerBloc = MusicPlayerBloc(musicPlayer: MusicPlayer(), vkApi: vkApi);
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
        BlocProvider<MusicPlayerBloc>(
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
        )
      ],
      child: MaterialApp(
        title: 'VK Music Player',
        navigatorKey: navigatorKey,
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
            )
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
