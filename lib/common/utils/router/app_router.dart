import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/models/playlist/playlist.dart';
import '../../../domain/model/player_audio.dart';
import '../../../ui/features/album/album_screen.dart';
import '../../../ui/features/album/widget/add_audio_screen.dart';
import '../../../ui/features/album/widget/edit_playlist_screen.dart';
import '../../../ui/features/albums/albums_screen_widget.dart';
import '../../../ui/features/artist/artist_screen.dart';
import '../../../ui/features/artist/widget/all_audios/all_songs_screen.dart';
import '../../../ui/features/audio/audio_screen_widget.dart';
import '../../../ui/features/audio_bottom_sheet/widgets/select_playlist.dart';
import '../../../ui/features/auth/auth_screen_widget.dart';
import '../../../ui/features/main/main_screen_widget.dart';
import '../../../ui/features/search/search_screen_widget.dart';
import '../../../ui/features/search/widget/all_audios/all_songs_screen.dart';
import '../../../ui/features/settings/settings_screen.dart';
import '../../../ui/features/tfa/tfa_screen.dart';
import '../../../ui/widgets/common/all_playlists_screen.dart';
import 'app_tabs.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen|Widget,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AuthRoute.page,
          path: '/auth',
          initial: true,
        ),
        AutoRoute(
          page: TfaRoute.page,
          path: '/tfa',
        ),
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          children: [
            AutoRoute(
              page: AudioTab.page,
              path: 'audio',
              children: [
                AutoRoute(
                  page: AudioRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AlbumRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ArtistRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: EditPlaylistRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AddAudioRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllPlaylistsRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllArtistSongsRoute.page,
                  path: '',
                ),
              ],
            ),
            AutoRoute(
              page: SearchTab.page,
              maintainState: false,
              path: 'search',
              children: [
                AutoRoute(
                  page: SearchRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AlbumRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ArtistRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllSongsRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AddAudioRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllPlaylistsRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllArtistSongsRoute.page,
                  path: '',
                ),
              ],
            ),
            AutoRoute(
              page: AlbumsTab.page,
              path: 'albums',
              children: [
                AutoRoute(
                  page: AlbumsRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AlbumRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ArtistRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: EditPlaylistRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AddAudioRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllPlaylistsRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: AllArtistSongsRoute.page,
                  path: '',
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          page: SelectPlaylistRoute.page,
          path: '/select_playlist',
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        ),
      ];
}
