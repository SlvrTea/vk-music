part of 'album_screen.dart';

abstract interface class IAlbumScreenWidgetModel implements IWidgetModel {
  User get user;

  AppTheme get theme;

  MediaQueryData get mediaQuery;

  EntityValueListenable<List<PlayerAudio>> get albumItems;

  EntityValueListenable<Playlist> get album;

  EntityValueListenable<bool> get downloading;

  EntityValueListenable<bool> get cached;

  Future<void> onFollowPlaylistTap();

  Future<void> onDeletePlaylistTap();

  Future<void> onEditPlaylistTap();

  Future<void> onCachePlaylistTap();

  Future<void> onDeleteCachedPlaylist();

  void playFrom();

  void playShuffled();

  Future<void> onMoreTap();
}

AlbumScreenWidgetModel defaultAlbumScreenWidgetModelFactory(
  BuildContext context,
) => AlbumScreenWidgetModel(AlbumScreenModel(context.global.audioRepository));

class AlbumScreenWidgetModel extends WidgetModel<AlbumScreen, IAlbumScreenModel>
    implements IAlbumScreenWidgetModel {
  AlbumScreenWidgetModel(super.model);

  @override
  User get user => context.global.user!;

  @override
  AppTheme get theme => wmTheme;

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  final _albumItemsEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get albumItems => _albumItemsEntity;

  final _albumEntity = EntityStateNotifier<Playlist>();

  @override
  EntityValueListenable<Playlist> get album => _albumEntity;

  final _downloadingEntity = EntityStateNotifier<bool>();

  @override
  EntityValueListenable<bool> get downloading => _downloadingEntity;

  final _cachedEntity = EntityStateNotifier<bool>();

  @override
  EntityValueListenable<bool> get cached => _cachedEntity;

  late final AppAudioPlayerController _player;

  @override
  void initWidgetModel() {
    _player = context.global.audioPlayer;

    _albumEntity.content(widget.playlist);
    _cachedEntity.content(
      model.cachedPlaylists.value.any((e) => e.name == widget.playlist.title),
    );
    model.cachedPlaylists.addListener(_listenCached);
    _downloadingEntity.content(
      model.downloadPlaylistInProgress.value.contains(widget.playlist.title),
    );
    model.downloadPlaylistInProgress.addListener(_listenDownload);
    _initAsync();
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.cachedPlaylists.removeListener(_listenCached);
    model.downloadPlaylistInProgress.removeListener(_listenDownload);
    super.dispose();
  }

  Future<void> _initAsync() async {
    await Future.wait([_loadItems()]);
  }

  void _listenDownload() {
    _downloadingEntity.content(
      model.downloadPlaylistInProgress.value.contains(widget.playlist.title),
    );
  }

  void _listenCached() {
    _cachedEntity.content(
      model.cachedPlaylists.value.any((e) => e.id == widget.playlist.id),
    );
  }

  Future<void> _loadItems() async {
    _albumItemsEntity.loading();
    final res = await model.loadAlbumAudios(widget.playlist);
    _albumItemsEntity.content(res);
  }

  @override
  Future<void> onFollowPlaylistTap() async {
    model.followPlaylist(widget.playlist);
    final album = _albumEntity.value.data!;
    _albumEntity.content(album.copyWith(isFollowing: true));
  }

  @override
  Future<void> onDeletePlaylistTap() async {
    model.deletePlaylist(widget.playlist);
    final album = _albumEntity.value.data!;
    if (album.ownerId.toString() == context.global.user?.userId) {
      context.maybePop();
    }
    _albumEntity.content(album.copyWith(isFollowing: false));
  }

  @override
  Future<void> onEditPlaylistTap() async {
    final res = await context.router.push<bool>(
      EditPlaylistRoute(playlist: _albumEntity.value.data!),
    );
    if (res == true) {
      await _loadItems();
    }
  }

  @override
  void playFrom() => _player.playFrom(playlist: _albumItemsEntity.value.data!);

  @override
  void playShuffled() => _player
    ..setShuffleModeEnabled(true)
    ..playFrom(playlist: _albumItemsEntity.value.data!);

  @override
  Future<void> onMoreTap() async {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context.findRootAncestorStateOfType<NavigatorState>()!.context,
      builder: (context) => AlbumMoreSheet(
        onEditTap: () async {
          context.maybePop();
          await onEditPlaylistTap();
        },
        onDeleteTap: () async {
          context.maybePop();
          await onDeletePlaylistTap();
        },
      ),
    );
  }

  @override
  Future<void> onCachePlaylistTap() async {
    try {
      await model.cachePlaylist(
        _albumItemsEntity.value.data!,
        widget.playlist.title,
        widget.playlist.id,
        widget.playlist.photo?.photo600,
      );
    } catch (e) {}
  }

  @override
  Future<void> onDeleteCachedPlaylist() async {
    try {
      await model.deleteCachedPlaylist(
        model.cachedPlaylists.value.firstWhere(
          (e) => e.id == widget.playlist.id,
        ),
      );
    } catch (e) {}
  }
}
