import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/models/music_player.dart';
import 'package:vk_music/domain/state/music_progress/music_progress_cubit.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';

import '../domain/state/auth/auth_bloc.dart';
import '../domain/state/music_loader/music_loader_cubit.dart';
import '../domain/state/music_player/music_player_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final navBar = NavBarCubit();
    final search = SearchCubit();
    final musicLoaderBloc = MusicLoaderCubit();
    final musicPlayerBloc = MusicPlayerCubit(musicPlayer: MusicPlayer());
    final musicProgress = MusicProgressCubit(musicPlayer: musicPlayerBloc.musicPlayer);
    final playlists = PlaylistsCubit();
    final authBloc = AuthBloc(musicLoader: musicLoaderBloc)
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
      child: MaterialApp(
        title: 'VK Music Player',
        navigatorKey: navigatorKey,
        scrollBehavior: const MaterialScrollBehavior()
            .copyWith(dragDevices: PointerDeviceKind.values.toSet(), physics: const BouncingScrollPhysics()),
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.purpleAccent,
            unselectedItemColor: Colors.grey
          ),
          drawerTheme: const DrawerThemeData(
            surfaceTintColor: Colors.black,
            backgroundColor: Colors.black,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 20, 20, 20)),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
            )
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 20, 20, 20)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
              )
          ),
          colorScheme: ColorScheme.fromSeed(
            background: Colors.black,
            seedColor: Colors.purple,
            primary: Colors.purpleAccent,
            brightness: Brightness.dark,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
          )
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
