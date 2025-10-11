part of 'album_screen.dart';

abstract interface class IAlbumScreenModel extends ElementaryModel {
  ListNotifier get downloadPlaylistInProgress;

  ListNotifier<CachedPlaylist> get cachedPlaylists;

  Future<List<PlayerAudio>> loadAlbumAudios(Playlist album);

  Future<void> followPlaylist(Playlist playlist);

  Future<void> deletePlaylist(Playlist album);

  Future<void> cachePlaylist(
    List<PlayerAudio> audios,
    String name,
    int id, [
    String? thumbUrl,
  ]);

  Future<void> deleteCachedPlaylist(CachedPlaylist playlist);
}

class AlbumScreenModel extends IAlbumScreenModel {
  AlbumScreenModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  ListNotifier get downloadPlaylistInProgress =>
      _audioRepository.downloadPlaylistInProgress;

  @override
  ListNotifier<CachedPlaylist> get cachedPlaylists =>
      _audioRepository.cachedPlaylistNotifier;

  @override
  Future<List<PlayerAudio>> loadAlbumAudios(Playlist album) async {
    final res = await _audioRepository.getAudios(
      ownerId: album.ownerId.toString(),
      albumId: album.id,
      isUserAudios: false,
    );
    return res.items;
  }

  @override
  Future<void> followPlaylist(Playlist playlist) =>
      _audioRepository.followPlaylist(playlist);

  @override
  Future<void> deletePlaylist(Playlist album) async {
    await _audioRepository.deletePlaylist(album);
  }

  @override
  Future<void> cachePlaylist(
    List<PlayerAudio> audios,
    String name,
    int id, [
    String? thumbUrl,
  ]) async {
    await _audioRepository.downloadPlaylist(audios, name, id, thumbUrl);
  }
  
  @override
  Future<void> deleteCachedPlaylist(CachedPlaylist playlist) async {
    await _audioRepository.deleteCachedPlaylist(playlist);
  }
}
