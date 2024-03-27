
import '../../data/service/vk_service.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/song.dart';

abstract class MusicRepository {
  Future<dynamic> get(List<Argument> args);

  Future<dynamic> getCurrentUserAudios();

  Future<dynamic> getPlaylistAudios(Playlist playlist);

  Future<dynamic> getArtist(String id);

  Future<dynamic> getAlbumsByArtist(Artist artist);

  Future<dynamic> getAudiosByArtist(Artist artist, {int count = 200, int? offset});

  Future<void> deleteAudio(Song song);

  Future<void> addAudio(Song song);

  Future<void> reorder(Song song, {String? before, String? after});

  Future<dynamic> getPlaylists({int count = 200, int? offset});

  Future<dynamic> getPlaylistMusic(Playlist playlist);

  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete});

  Future<dynamic> savePlaylist({required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder});

  Future<dynamic> addAudiosToPlaylist(Playlist playlist, List<Song> audiosToAdd);

  Future<dynamic> search(String q, {int count = 50, int? offset});

  Future<dynamic> searchAlbum(String q);

  Future<dynamic> searchPlaylist(String q);

  Future<dynamic> getRecommendations({int count = 50, int? offset});

  Future<void> followPlaylist(Playlist playlist);

  Future<void> deletePlaylist(Playlist playlist);

  Future<dynamic> getCatalog();
}