
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vk_music/core/data/service/vk_service.dart';

import '../../../feature/artist_tab/domain/model/artist.dart';
import '../../domain/models/playlist.dart';
import '../../domain/models/song.dart';
import '../../domain/models/user.dart';


class VKAudioService extends VKService {
  User get user => Hive.box('userBox').get('user');

  /// Add an audio to the user audios
  Future<void> add(Song audio) async {
    method('audio.add', [
      Argument.owner(audio.ownerId),
      Argument('audio_id', audio.shortId)
    ]);
    log('${audio.toString()} added to user audios.');
  }

  /// Add audios to the specified [Playlist]
  Future<Playlist?> addToPlaylist(Playlist playlist, List<Song> audios) async {
    final audioIds = [];
    for (Song element in audios) {
      audioIds.add(element.id);
    }
    final response = await method('audio.addToPlaylist', [
      Argument.owner(user.userId),
      Argument('playlist_id', playlist.id),
      Argument('audio_ids', audioIds.join(','))
    ]);
    log(response.data.toString());
    log('${audios.length} songs added to $playlist playlist.');
    return Playlist.fromMap(response.data['response']['playlist']);
  }

  /// Delete an audio from user audios
  Future<void> delete(Song audio) async {
    method('audio.delete', [
      Argument.owner(user.userId),
      Argument('audio_id', audio.shortId)
    ]);
    log('${audio.toString()} deleted from user audios.');
  }

  /// Delete a playlist from the user audios
  Future<void> deletePlaylist(Playlist playlist) async {
    method('audio.deletePlaylist', [
      Argument.owner(user.userId),
      Argument('playlist_id', playlist.ownerId)
    ]);
    log('$playlist deleted from user audios.');
  }

  /// Add playlist to the user audios
  Future<void> followPlaylist(Playlist playlist) async {
    method('audio.followPlaylist', [
      Argument.owner(user.userId),
      Argument('playlist_id', playlist.ownerId)
    ]);
    log('$playlist added to user audios.');
  }

  /// Get audios for a specified [User], community or [Playlist].
  /// If both owner_id and album_id are not specified,
  /// this method returns current [User] audios (for which the token was obtained).
  /// It's strongly recommend to use some other methods like
  /// [getCurrentUserAudios] or [getPlaylistAudios]
  Future<List<Song>?> get(List<Argument>? args) async {
    final response = await method('audio.get', args);

    late dynamic data;
    if (response.data['response'] == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Song.fromMap(e))
          .toList();
    }
    return data;
  }

  /// Get current [User] audios
  Future<List<Song>?> getCurrentUserAudios({int count = 2000, int? offset = 50}) async {
    final audios = get([
      Argument.count(count),
      Argument.offset(offset)
    ]);
    log('Loading user audios.');
    return audios;
  }

  /// Get audios from specified [Playlist]
  Future<List<Song>?> getPlaylistAudios(Playlist playlist, {int count = 200, int? offset}) async {
    final audios = get([
      Argument.owner(playlist.ownerId),
      Argument('album_id', playlist.id),
      Argument.count(count),
      Argument.offset(offset)
    ]);
    log('$playlist audios loaded');
    return audios;
  }

  /// Get albums by [Artist]
  Future<List<Playlist>?> getAlbumsByArtist(Artist artist, {int count = 200, int? offset}) async {
    final response = await method('audio.getAlbumsByArtist', [
      Argument('artist_id', artist.id),
      Argument.count(count),
      Argument.offset(offset)
    ]);

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

  /// Get information about [Artist] by id
  Future<Artist?> getArtistById(String artistId) async {
    final response = await method('audio.getArtistById', [
      Argument('artist_id', artistId)
    ]);
    return Artist.fromMap(response.data['response']);
  }

  /// Get audios by artist
  Future<List<Song>> getAudiosByArtist(Artist artist, {int count = 200, int? offset}) async {
    final response = await method('audio.getAudiosByArtist', [
      Argument('artist_id', artist.id),
      Argument.count(count),
      Argument.offset(offset)
    ]);

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

  /// Get [User] playlists
  Future<List<Playlist>?> getPlaylists({int count = 200, int? offset}) async {
    final response = await method('audio.getPlaylists', [
      Argument.owner(user.userId),
      Argument.count(count),
      Argument.offset(offset),
    ]);
    late dynamic data;
    if (response.data == null) {
      data = response.data['error']['error_msg'];
      throw response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Playlist.fromMap(e))
          .toList();
    }
    log('User playlists loaded.');
    return data;
  }

  /// Get suggest audios
  Future<List<Song>?> getRecommendations({int count = 50, int? offset}) async {
    final response = await method('audio.getRecommendations', [
      Argument.count(count),
      Argument.offset(offset)
    ]);
    return (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(e))
        .toList();
  }


  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete}) async {
    final audios = songsToDelete.map((e) => e.id).toList().join(',');
    method('audio.removeFromPlaylist', [
      Argument('playlist_id', playlist.id),
      Argument.owner(user.userId),
      Argument('audio_ids', audios)
    ]);
  }

  /// Move one audio before other in [User] audios.
  ///
  /// One of [before] or [after] arguments must not be null.
  Future<void> reorder(Song song, {String? before, String? after}) async {
    assert(!(before != null && after != null));
    final User user = Hive.box('userBox').get('user');
    final response = await method('audio.reorder', [
      Argument.owner(user.userId),
      Argument('audio_id', song.shortId),
      Argument('after', after),
      Argument('before', before)
    ]);
    log('Reorder action: ${song.toString()} now ${before ?? after}');
    log(response.data.toString());
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

    final response = await method('execute.savePlaylist', [
      Argument.owner(playlist.ownerId),
      Argument('playlist_id', playlist.id),
      Argument('title', title ?? playlist.title),
      Argument('description', description ?? playlist.description),
      Argument('audio_ids_to_add', songsToAdd?.map((e) => e.id).toList().join(','))
    ]);
    return Playlist.fromMap(response.data['response']['playlist']);
  }

  /// Search audios by name
  Future<dynamic> search(String q, {int count = 50, int? offset}) async {
    final response = await method('audio.search', [
      Argument('q', q),
      Argument.count(count),
      Argument.offset(offset),
    ]);
    return (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(e))
        .toList();
  }

  /// Search albums by name
  Future<dynamic> searchAlbum(String q, {int count = 100, int? offset}) async {
    final response = await method('audio.searchAlbums', [
      Argument('q', q),
      Argument.count(count),
      Argument.offset(offset),
    ]);
    return (response.data['response']['items'] as List)
        .map((e) => Playlist.fromMap(e).copyWith(isOwner: false))
        .toList();
  }

  Future<dynamic> searchPlaylists(String q, {int count = 100, int? offset}) async {
    final response = await method('audio.searchPlaylists', [
      Argument('q', q),
      Argument.count(count),
      Argument.offset(offset),
    ]);
    return (response.data['response']['items'] as List)
        .map((e) => Playlist.fromMap(e).copyWith(isOwner: false))
        .toList();
  }

  /// Get current user sections or search for artists.
  ///
  /// If neither [artistId] nor [query] are specified, sections for the current [User] are returned.
  Future<dynamic> getCatalog({String? query, String? artistId, String? contextId, int count = 200, int? offset}) async {
    final response = await method('audio.getCatalog', [
      Argument('artist_id', artistId),
      Argument('query', query),
      Argument('context', contextId),
      Argument.count(count),
      Argument.offset(offset)
    ]);
    log(response.data.toString());
  }
}