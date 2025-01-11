import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';

import '../../feature/auth/domain/state/auth_bloc.dart';
import '../../feature/auth/presentation/login_screen.dart';
import '../../feature/playlists_tab/domain/state/playlists_cubit.dart';
import '../../feature/search_tab/domain/state/search_cubit.dart';
import '../domain/const.dart';
import '../domain/models/music_player.dart';
import '../domain/state/music_loader/music_loader_cubit.dart';
import '../domain/state/music_player/music_player_cubit.dart';
import '../domain/state/music_progress/music_progress_cubit.dart';
import '../domain/state/nav_bar/nav_bar_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final navBar = NavBarCubit();
    final search = SearchCubit()..getRecommendations();
    final musicLoaderBloc = MusicLoaderCubit();
    final musicPlayerBloc = MusicPlayerCubit(musicPlayer: MusicPlayer());
    final musicProgress =
        MusicProgressCubit(musicPlayer: musicPlayerBloc.musicPlayer);
    final playlists = PlaylistsCubit();
    final authBloc = AuthBloc(musicLoader: musicLoaderBloc)
      ..add(LoadUserEvent());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => authBloc),
        BlocProvider<MusicLoaderCubit>(create: (context) => musicLoaderBloc),
        BlocProvider<MusicPlayerCubit>(create: (context) => musicPlayerBloc),
        BlocProvider<NavBarCubit>(create: (context) => navBar),
        BlocProvider<PlaylistsCubit>(create: (_) => playlists),
        BlocProvider<MusicProgressCubit>(create: (_) => musicProgress),
        BlocProvider<SearchCubit>(create: (_) => search)
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          // Use system colors for accents but keep dark background
          final colorScheme = (darkDynamic ??
                  ColorScheme.fromSeed(
                    seedColor: Colors.purple,
                    brightness: Brightness.dark,
                  ))
              .copyWith(
            background: Colors.black,
            surface: Colors.black,
          );

          return MaterialApp(
            title: 'VK Music Player',
            navigatorKey: navigatorKey,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: PointerDeviceKind.values.toSet(),
                physics: const BouncingScrollPhysics()),
            theme: ThemeData(
                useMaterial3: true,
                appBarTheme: AppBarTheme(
                  backgroundColor:
                      colorScheme.background.withAlpha(179), // 0.7 * 255 ≈ 179
                ),
                snackBarTheme: SnackBarThemeData(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 5),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: colorScheme.background.withAlpha(179),
                    selectedItemColor: colorScheme.primary,
                    unselectedItemColor: Colors.grey),
                drawerTheme: const DrawerThemeData(
                  surfaceTintColor: Colors.black,
                  backgroundColor: Colors.black,
                ),
                filledButtonTheme: FilledButtonThemeData(
                    style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  backgroundColor: const MaterialStatePropertyAll(
                      Color.fromARGB(255, 20, 20, 20)),
                  foregroundColor:
                      MaterialStatePropertyAll(colorScheme.onSurface),
                )),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  backgroundColor: const MaterialStatePropertyAll(
                      Color.fromARGB(255, 20, 20, 20)),
                  foregroundColor:
                      MaterialStatePropertyAll(colorScheme.onSurface),
                )),
                colorScheme: colorScheme,
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.black,
                  surfaceTintColor: Colors.black,
                )),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
