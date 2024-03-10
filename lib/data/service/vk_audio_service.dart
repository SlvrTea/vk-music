
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/data/service/vk_service.dart';
import '../../domain/models/artist.dart';
import '../../domain/models/playlist.dart';
import '../../domain/models/song.dart';
import '../../domain/models/user.dart';

class VKAudioService extends VKService {
  User get user => Hive.box('userBox').get('user');

  /// Add an audio to the user audios
  Future<void> add(Song audio) async {
    method('audio.add', 'owner_id=${audio.ownerId}&audio_id=${audio.shortId}');
    log('${audio.toString()} added to user audios.');
  }

  /// Add audios to the specified playlist
  Future<Playlist?> addToPlaylist(Playlist playlist, List<Song> audios) async {
    final audioIds = [];
    for (Song element in audios) {
      audioIds.add(element.id);
    }
    final response = await method('audio.addToPlaylist',
        'owner_id=${user.userId}&playlist_id=${playlist.id}&audio_ids=${audioIds.join(',')}');
    log('${audios.length} songs added to $playlist playlist.');
    return Playlist.fromMap(response.data['response']['playlist']);
  }

  /// Delete an audio from user audios
  Future<void> delete(Song audio) async {
    method('audio.delete', 'owner_id=${user.userId}&audio_id=${audio.shortId}');
    log('${audio.toString()} deleted from user audios.');
  }

  /// Delete a playlist from the user audios
  Future<void> deletePlaylist(Playlist playlist) async {
    method('audio.deletePlaylist',
        'playlist_id=${playlist.id}&owner_id=${playlist.ownerId}');
    log('$playlist deleted from user audios.');
  }

  /// Add playlist to the user audios
  Future<void> followPlaylist(Playlist playlist) async {
    method('audio.followPlaylist',
        'playlist_id=${playlist.id}&owner_id=${playlist.ownerId}');
    log('$playlist added to user audios.');
  }

  /// Get audios for a specified user, community or playlist.
  /// If both owner_id and album_id are not specified,
  /// this method returns current user audios (for which the token was obtained).
  /// It's strongly recommend to use some other methods like
  /// [getCurrentUserAudios] or [getPlaylistAudios}
  Future<List<Song>?> get(String args) async {
    final response = await method('audio.get', args);

    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Song.fromMap(e))
          .toList();
    }
    log(response.data.toString());
    return data;
  }

  /// Get current user audios
  Future<List<Song>?> getCurrentUserAudios({int? count, int? offset}) async {
    final audios = get(
        'count=20000'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    log('Loading user audios.');
    return audios;
  }

  Future<List<Song>?> getPlaylistAudios(Playlist playlist, 
      {int? count, int? offset}) async {
    final audios = get('owner_id=${playlist.ownerId}&album_id=${playlist.id}'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    log('$playlist audios loaded');
    return audios;
  }

  /// Get albums by artist
  Future<List<Playlist>?> getAlbumsByArtist(Artist artist, 
      {int? count, int? offset}) async {
    final response = await method('audio.getAlbumsByArtist',
        'artist_id=${artist.id}'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );

    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Playlist.fromMap(e))
          .toList();
    }
    log('$artist albums loaded.');
    return data;
  }

  /// Get information about artist by id
  Future<Artist?> getArtistById(String artistId) async {
    final response = await method('audio.getArtistById',
        'artist_id=$artistId&extended=1');
    log(response.data.toString());
  }

  /// Get audios by artist
  Future<List<Song>> getAudiosByArtist(Artist artist, {int? count, int? offset}) async {
    final response = await method('audio.getAudiosByArtist',
        'artist_id=${artist.id}'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );

    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Song.fromMap(e))
          .toList();
    }
    log('$artist audios loaded.');
    return data;
  }

  /// Get count of user audios
  Future<dynamic> getCount() async => await method('audio.getCount', 'owner_id=${user.userId}');

  /// Get user playlists
  Future<List<Playlist>?> getPlaylists() async {
    final response = await method('audio.getPlaylists', 'owner_id=${user.userId}');

    late dynamic data;
    if (response.data == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Playlist.fromMap(e))
          .toList();
    }
    log('User playlists loaded.');
    return data;
  }

  /// Get suggest audios
  Future<List<Song>?> getRecommendations({int? offset}) async {
    final response = await method('audio.getRecommendations',
        'user_id=${user.userId}&count=50${offset == null ? '' : '&offset=$offset'}'
    );
    return (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(e))
        .toList();
  }

  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete}) async {
    final audios = songsToDelete.map((e) => e.id).toList().join(',');
    method('audio.removeFromPlaylist', 'playlist_id=${playlist.id}&owner_id=${user.userId}&audio_ids=$audios');
  }

  Future<void> reorder(Song song, {String? before, String? after}) async {
    assert(before != null && after != null);
    final User user = Hive.box('userBox').get('user');
    method('audio.reorder',
        'owner_id=${user.userId}&audio_id=${song.shortId}'
            '${before == null ? '' : '&before=$before'}'
            '${after == null ? '' : '&after=$after'}'
    );
    log('Reorder action: ${song.toString()} now ${before ?? after}');
  }

  Future<dynamic> savePlaylist(
      {required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder}) async {
    String reorderFormat = '';
    if (reorder != null && reorder.isNotEmpty) {
      reorderFormat += '[';
      for (List element in reorder) {
        if (element != reorder.last) {
          reorderFormat += '[${element.join(',')}],';
        } else {
          reorderFormat += '[${element.join(',')}]';
        }
      }
      reorderFormat += ']';
    }
    final response = await method('execute.savePlaylist',
        'owner_id=${playlist.ownerId}'
            '&playlist_id=${playlist.id}'
            '&title=${title ?? playlist.title}'
            '&description=${description ?? playlist.description}'
            '${songsToAdd == null ? '' : '&audio_ids_to_add=${songsToAdd.map((e) => e.id).toList().join(',')}'}'
            '${reorder == null ? '' : '&reorder_actions=$reorderFormat'}'
    );

    return Playlist.fromMap(response.data['response']);
  }

  Future<dynamic> search(String q, {int? count, int? offset}) async {
    final response = await method('audio.search',
        'q=$q'
            '${count != null ? '&count=$count' : ''}'
            '${offset != null ? '&offset=$offset' : ''}'
    );
    return (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(e))
        .toList();
  }

  Future<dynamic> searchAlbum(String q) async {
    final response = await method('audio.searchAlbums', 'q=$q');
    return (response.data['response']['items'] as List)
        .map((e) => Playlist.fromMap(e).copyWith(isOwner: false))
        .toList();
  }

  Future<dynamic> searchPlaylists(String q) async {
    final response = await method('audio.searchPlaylists', 'q=$q');
    return (response.data['response']['items'] as List)
        .map((e) => Playlist.fromMap(e).copyWith(isOwner: false))
        .toList();
  }
}