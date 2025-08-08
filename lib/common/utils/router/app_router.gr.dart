// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddAudioScreen]
class AddAudioRoute extends PageRouteInfo<AddAudioRouteArgs> {
  AddAudioRoute({
    Key? key,
    required List<PlayerAudio> playlistAudios,
    List<PageRouteInfo>? children,
  }) : super(
          AddAudioRoute.name,
          args: AddAudioRouteArgs(
            key: key,
            playlistAudios: playlistAudios,
          ),
          initialChildren: children,
        );

  static const String name = 'AddAudioRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddAudioRouteArgs>();
      return AddAudioScreen(
        key: args.key,
        playlistAudios: args.playlistAudios,
      );
    },
  );
}

class AddAudioRouteArgs {
  const AddAudioRouteArgs({
    this.key,
    required this.playlistAudios,
  });

  final Key? key;

  final List<PlayerAudio> playlistAudios;

  @override
  String toString() {
    return 'AddAudioRouteArgs{key: $key, playlistAudios: $playlistAudios}';
  }
}

/// generated route for
/// [AlbumScreen]
class AlbumRoute extends PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    Key? key,
    required Playlist playlist,
    List<PageRouteInfo>? children,
  }) : super(
          AlbumRoute.name,
          args: AlbumRouteArgs(
            key: key,
            playlist: playlist,
          ),
          initialChildren: children,
        );

  static const String name = 'AlbumRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AlbumRouteArgs>();
      return AlbumScreen(
        key: args.key,
        playlist: args.playlist,
      );
    },
  );
}

class AlbumRouteArgs {
  const AlbumRouteArgs({
    this.key,
    required this.playlist,
  });

  final Key? key;

  final Playlist playlist;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, playlist: $playlist}';
  }
}

/// generated route for
/// [AlbumsScreen]
class AlbumsRoute extends PageRouteInfo<void> {
  const AlbumsRoute({List<PageRouteInfo>? children})
      : super(
          AlbumsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AlbumsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlbumsScreen();
    },
  );
}

/// generated route for
/// [AlbumsTapPage]
class AlbumsTab extends PageRouteInfo<void> {
  const AlbumsTab({List<PageRouteInfo>? children})
      : super(
          AlbumsTab.name,
          initialChildren: children,
        );

  static const String name = 'AlbumsTab';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlbumsTapPage();
    },
  );
}

/// generated route for
/// [AllArtistSongsScreen]
class AllArtistSongsRoute extends PageRouteInfo<AllArtistSongsRouteArgs> {
  AllArtistSongsRoute({
    Key? key,
    required String artistId,
    required List<PlayerAudio> initialAudios,
    List<PageRouteInfo>? children,
  }) : super(
          AllArtistSongsRoute.name,
          args: AllArtistSongsRouteArgs(
            key: key,
            artistId: artistId,
            initialAudios: initialAudios,
          ),
          initialChildren: children,
        );

  static const String name = 'AllArtistSongsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllArtistSongsRouteArgs>();
      return AllArtistSongsScreen(
        key: args.key,
        artistId: args.artistId,
        initialAudios: args.initialAudios,
      );
    },
  );
}

class AllArtistSongsRouteArgs {
  const AllArtistSongsRouteArgs({
    this.key,
    required this.artistId,
    required this.initialAudios,
  });

  final Key? key;

  final String artistId;

  final List<PlayerAudio> initialAudios;

  @override
  String toString() {
    return 'AllArtistSongsRouteArgs{key: $key, artistId: $artistId, initialAudios: $initialAudios}';
  }
}

/// generated route for
/// [AllPlaylistsScreen]
class AllPlaylistsRoute extends PageRouteInfo<AllPlaylistsRouteArgs> {
  AllPlaylistsRoute({
    Key? key,
    required List<Playlist> playlists,
    List<PageRouteInfo>? children,
  }) : super(
          AllPlaylistsRoute.name,
          args: AllPlaylistsRouteArgs(
            key: key,
            playlists: playlists,
          ),
          initialChildren: children,
        );

  static const String name = 'AllPlaylistsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllPlaylistsRouteArgs>();
      return AllPlaylistsScreen(
        key: args.key,
        playlists: args.playlists,
      );
    },
  );
}

class AllPlaylistsRouteArgs {
  const AllPlaylistsRouteArgs({
    this.key,
    required this.playlists,
  });

  final Key? key;

  final List<Playlist> playlists;

  @override
  String toString() {
    return 'AllPlaylistsRouteArgs{key: $key, playlists: $playlists}';
  }
}

/// generated route for
/// [AllSongsScreen]
class AllSongsRoute extends PageRouteInfo<AllSongsRouteArgs> {
  AllSongsRoute({
    Key? key,
    required String query,
    required List<PlayerAudio> initialAudios,
    List<PageRouteInfo>? children,
  }) : super(
          AllSongsRoute.name,
          args: AllSongsRouteArgs(
            key: key,
            query: query,
            initialAudios: initialAudios,
          ),
          initialChildren: children,
        );

  static const String name = 'AllSongsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllSongsRouteArgs>();
      return AllSongsScreen(
        key: args.key,
        query: args.query,
        initialAudios: args.initialAudios,
      );
    },
  );
}

class AllSongsRouteArgs {
  const AllSongsRouteArgs({
    this.key,
    required this.query,
    required this.initialAudios,
  });

  final Key? key;

  final String query;

  final List<PlayerAudio> initialAudios;

  @override
  String toString() {
    return 'AllSongsRouteArgs{key: $key, query: $query, initialAudios: $initialAudios}';
  }
}

/// generated route for
/// [ArtistScreen]
class ArtistRoute extends PageRouteInfo<ArtistRouteArgs> {
  ArtistRoute({
    required String artistId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ArtistRoute.name,
          args: ArtistRouteArgs(
            artistId: artistId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ArtistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ArtistRouteArgs>();
      return ArtistScreen(
        args.artistId,
        key: args.key,
      );
    },
  );
}

class ArtistRouteArgs {
  const ArtistRouteArgs({
    required this.artistId,
    this.key,
  });

  final String artistId;

  final Key? key;

  @override
  String toString() {
    return 'ArtistRouteArgs{artistId: $artistId, key: $key}';
  }
}

/// generated route for
/// [AudioScreen]
class AudioRoute extends PageRouteInfo<void> {
  const AudioRoute({List<PageRouteInfo>? children})
      : super(
          AudioRoute.name,
          initialChildren: children,
        );

  static const String name = 'AudioRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AudioScreen();
    },
  );
}

/// generated route for
/// [AudioTabPage]
class AudioTab extends PageRouteInfo<void> {
  const AudioTab({List<PageRouteInfo>? children})
      : super(
          AudioTab.name,
          initialChildren: children,
        );

  static const String name = 'AudioTab';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AudioTabPage();
    },
  );
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [EditPlaylistScreen]
class EditPlaylistRoute extends PageRouteInfo<EditPlaylistRouteArgs> {
  EditPlaylistRoute({
    Key? key,
    required Playlist playlist,
    List<PageRouteInfo>? children,
  }) : super(
          EditPlaylistRoute.name,
          args: EditPlaylistRouteArgs(
            key: key,
            playlist: playlist,
          ),
          initialChildren: children,
        );

  static const String name = 'EditPlaylistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditPlaylistRouteArgs>();
      return EditPlaylistScreen(
        key: args.key,
        playlist: args.playlist,
      );
    },
  );
}

class EditPlaylistRouteArgs {
  const EditPlaylistRouteArgs({
    this.key,
    required this.playlist,
  });

  final Key? key;

  final Playlist playlist;

  @override
  String toString() {
    return 'EditPlaylistRouteArgs{key: $key, playlist: $playlist}';
  }
}

/// generated route for
/// [KateAuthWidget]
class KateAuthRoute extends PageRouteInfo<void> {
  const KateAuthRoute({List<PageRouteInfo>? children})
      : super(
          KateAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'KateAuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KateAuthWidget();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    String? initialQuery,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            initialQuery: initialQuery,
          ),
          rawPathParams: {'q': initialQuery},
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SearchRouteArgs>(
          orElse: () =>
              SearchRouteArgs(initialQuery: pathParams.optString('q')));
      return SearchScreen(
        key: args.key,
        initialQuery: args.initialQuery,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.initialQuery,
  });

  final Key? key;

  final String? initialQuery;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, initialQuery: $initialQuery}';
  }
}

/// generated route for
/// [SearchTapPage]
class SearchTab extends PageRouteInfo<void> {
  const SearchTab({List<PageRouteInfo>? children})
      : super(
          SearchTab.name,
          initialChildren: children,
        );

  static const String name = 'SearchTab';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchTapPage();
    },
  );
}

/// generated route for
/// [SelectPlaylistWidget]
class SelectPlaylistRoute extends PageRouteInfo<SelectPlaylistRouteArgs> {
  SelectPlaylistRoute({
    Key? key,
    required PlayerAudio song,
    required List<Playlist> ownedPlaylists,
    required void Function(
      Playlist,
      PlayerAudio,
    ) addToPlaylist,
    List<PageRouteInfo>? children,
  }) : super(
          SelectPlaylistRoute.name,
          args: SelectPlaylistRouteArgs(
            key: key,
            song: song,
            ownedPlaylists: ownedPlaylists,
            addToPlaylist: addToPlaylist,
          ),
          initialChildren: children,
        );

  static const String name = 'SelectPlaylistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectPlaylistRouteArgs>();
      return SelectPlaylistWidget(
        key: args.key,
        song: args.song,
        ownedPlaylists: args.ownedPlaylists,
        addToPlaylist: args.addToPlaylist,
      );
    },
  );
}

class SelectPlaylistRouteArgs {
  const SelectPlaylistRouteArgs({
    this.key,
    required this.song,
    required this.ownedPlaylists,
    required this.addToPlaylist,
  });

  final Key? key;

  final PlayerAudio song;

  final List<Playlist> ownedPlaylists;

  final void Function(
    Playlist,
    PlayerAudio,
  ) addToPlaylist;

  @override
  String toString() {
    return 'SelectPlaylistRouteArgs{key: $key, song: $song, ownedPlaylists: $ownedPlaylists, addToPlaylist: $addToPlaylist}';
  }
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
