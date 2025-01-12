part of 'album_screen.dart';

abstract interface class IAlbumScreenModel extends ElementaryModel {
  Future<List<Song>> loadAlbumAudios(Playlist album);

  Future<void> followPlaylist(Playlist playlist);

  Future<void> deletePlaylist(Playlist album);
}

class AlbumScreenModel extends IAlbumScreenModel {
  AlbumScreenModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  Future<List<Song>> loadAlbumAudios(Playlist album) async {
    final res = await _audioRepository.getAudios(
      ownerId: album.ownerId.toString(),
      albumId: album.id,
      isUserAudios: false,
    );
    return res.items;
  }

  @override
  Future<void> followPlaylist(Playlist playlist) => _audioRepository.followPlaylist(playlist);

  @override
  Future<void> deletePlaylist(Playlist album) async {
    await _audioRepository.deletePlaylist(album);
  }
}
