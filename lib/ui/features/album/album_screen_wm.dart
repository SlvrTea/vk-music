part of 'album_screen.dart';

abstract interface class IAlbumScreenWidgetModel implements IWidgetModel {
  User get user;

  AppTheme get theme;

  MediaQueryData get mediaQuery;

  EntityValueListenable<List<PlayerAudio>> get albumItems;

  EntityValueListenable<Playlist> get album;

  Future<void> onFollowPlaylistTap();

  Future<void> onDeletePlaylistTap();

  Future<void> onEditPlaylistTap();

  void playFrom();

  void playShuffled();
}

AlbumScreenWidgetModel defaultAlbumScreenWidgetModelFactory(BuildContext context) =>
    AlbumScreenWidgetModel(AlbumScreenModel(
      context.global.audioRepository,
    ));

class AlbumScreenWidgetModel extends WidgetModel<AlbumScreen, IAlbumScreenModel> implements IAlbumScreenWidgetModel {
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

  late final AppAudioPlayer _player;

  @override
  void initWidgetModel() {
    _player = context.global.audioPlayer;

    _albumEntity.content(widget.playlist);
    _initAsync();
    super.initWidgetModel();
  }

  Future<void> _initAsync() async {
    await Future.wait([
      _loadItems(),
    ]);
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
    _albumEntity.content(album.copyWith(isFollowing: false));
  }

  @override
  Future<void> onEditPlaylistTap() async {
    final res = await context.router.push<bool?>(EditPlaylistRoute(playlist: _albumEntity.value.data!));
    if (res == true) {
      await _loadItems();
    }
  }

  @override
  void playFrom() => _player.playFrom(playlist: PlayerPlaylist(children: _albumItemsEntity.value.data!));

  @override
  void playShuffled() => _player
    ..setShuffleModeEnabled(true)
    ..playFrom(playlist: PlayerPlaylist(children: _albumItemsEntity.value.data!));
}
