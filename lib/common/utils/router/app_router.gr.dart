// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

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
/// [AllSongsScreen]
class AllSongsRoute extends PageRouteInfo<AllSongsRouteArgs> {
  AllSongsRoute({
    Key? key,
    required String query,
    required List<Song> initialAudios,
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

  final List<Song> initialAudios;

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
    required Song song,
    required List<Playlist> ownedPlaylists,
    required void Function(Playlist) addToPlaylist,
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

  final Song song;

  final List<Playlist> ownedPlaylists;

  final void Function(Playlist) addToPlaylist;

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

/// generated route for
/// [TfaScreen]
class TfaRoute extends PageRouteInfo<TfaRouteArgs> {
  TfaRoute({
    Key? key,
    required Map<String, dynamic> query,
    required String redirect,
    List<PageRouteInfo>? children,
  }) : super(
          TfaRoute.name,
          args: TfaRouteArgs(
            key: key,
            query: query,
            redirect: redirect,
          ),
          initialChildren: children,
        );

  static const String name = 'TfaRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TfaRouteArgs>();
      return TfaScreen(
        key: args.key,
        query: args.query,
        redirect: args.redirect,
      );
    },
  );
}

class TfaRouteArgs {
  const TfaRouteArgs({
    this.key,
    required this.query,
    required this.redirect,
  });

  final Key? key;

  final Map<String, dynamic> query;

  final String redirect;

  @override
  String toString() {
    return 'TfaRouteArgs{key: $key, query: $query, redirect: $redirect}';
  }
}
