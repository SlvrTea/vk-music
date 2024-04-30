import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/feature/auth/presentation/login_screen.dart';
import 'package:vk_music/feature/home_screen/presentation/home.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/playlist_edit_screen.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/select_playlist.dart';
import 'package:vk_music/feature/tfa/tfa.dart';

import '../../feature/artist_tab/presentation/artist_tab.dart';
import '../../feature/playlist_tab/presentation/playlist_tab.dart';
import '../../feature/playlists_tab/presentation/playlists_tab.dart';
import '../../feature/search_tab/presentation/search_tab.dart';
import '../domain/models/playlist.dart';

final _shellKey = GlobalKey<NavigatorState>();
final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(navigatorKey: _rootKey,
    routes: [
  GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
  GoRoute(
      path: '/tfa/:redirect',
      builder: (_, state) => Tfa(
          redirect: state.pathParameters['redirect']!,
          query: (state.extra as Map<String, dynamic>))),
  ShellRoute(
      navigatorKey: _shellKey,
      builder: (_, __, child) => child,
      routes: [
        GoRoute(path: '/audios', builder: (_, __) => const HomeTab()),
        GoRoute(
            path: '/search',
            builder: (_, __) => const SearchTab(),
            routes: [
              //GoRoute(path: 'all_songs'),
              //GoRoute(path: 'all_albums'),
              //GoRoute(path: 'all_playlists')
            ]),
        GoRoute(
            path: '/playlists', builder: (_, __) => const PlaylistsTab()),
        GoRoute(
            parentNavigatorKey: _shellKey,
            path: '/artist',
            builder: (_, state) =>
                ArtistTab(state.uri.queryParameters['artist_id']!),
            routes: [
              //GoRoute(path: 'all_songs'),
              //GoRoute(path: 'all_albums'),
              //GoRoute(path: 'all_playlists')
            ]),
        GoRoute(
            parentNavigatorKey: _shellKey,
            path: '/select_playlist',
            builder: (_, state) => SelectPlaylist((state.extra as Map)['song'],
                (state.extra as Map)['owned_playlists'])),
        GoRoute(
            parentNavigatorKey: _shellKey,
            path: '/playlist',
            builder: (_, state) => PlaylistTab(state.extra as Playlist),
            routes: [
              GoRoute(
                  parentNavigatorKey: _shellKey,
                  path: 'edit',
                  builder: (_, state) => PlaylistEdit(state.extra as Playlist))
            ]),
      ])
]);
