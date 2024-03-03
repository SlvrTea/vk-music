
import '../models/playlist.dart';
import '../models/song.dart';

abstract class MusicRepository {
  Future<dynamic> getMusic(String args);

  Future<void> deleteAudio(Song song);

  Future<void> addAudio(Song song);

  Future<void> reorder(Song song, {String? before, String? after});

  Future<dynamic> getPlaylists(String args);

  Future<dynamic> getPlaylistMusic(Playlist playlist);

  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete});

  Future<dynamic> savePlaylist({required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder});

  Future<dynamic> addAudiosToPlaylist(Playlist playlist, List<String> audiosToAdd);

  Future<dynamic> search(String q, {int? count, int? offset});

  Future<dynamic> searchAlbum(String q);

  Future<dynamic> searchPlaylist(String q);

  Future<dynamic> getRecommendations({int? offset});

  Future<void> followPlaylist(Playlist playlist);

  Future<void> deletePlaylist(Playlist playlist);
}