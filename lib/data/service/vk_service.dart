
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/playlist.dart';
import '../../domain/models/song.dart';
import '../../domain/models/user.dart';

class VKService {
  Future<Response<dynamic>> method(String method, String args, {bool isNew = false}) async {
    final User user = Hive.box('userBox').get('user');
    final deviceId = _getRandomString(16);
    const v = 5.95;

    String url =
        '/method/$method?v=${isNew ? 5.116 : v}&access_token=${user.accessToken}&device_id=$deviceId&$args';
    final hash = crypto.md5.convert(utf8.encode(url + user.secret));

    var response = await Dio().get('https://api.vk.com$url&sig=$hash',
        options: Options(headers: {
          "User-Agent":
          "VKAndroidApp/4.13.1-1206 (Android 4.4.3; SDK 19; armeabi; ; ru)",
          "Accept": "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*"
        }
      ));
    return response;
  }

  Future<dynamic> getMusic(String args) async {
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

  Future<void> deleteAudio(Song song) async {
    final User user = Hive.box('userBox').get('user');
    method('audio.delete', 'owner_id=${user.userId}&audio_id=${song.shortId}');
    log('Deleting following audio: ${song.toString()}');
  }

  Future<void> addAudio(Song audio) async {
    method('audio.add', 'owner_id=${audio.ownerId}&audio_id=${audio.shortId}');
    log('Adding following audio: ${audio.toString()}');
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

  Future<dynamic> getPlaylists(String args) async {
    final User user = Hive.box('userBox').get('user');
    final response = await method('audio.getPlaylists', 'owner_id=${user.userId}');

    late dynamic data;
    if (response.data == null) {
      data = response.data['error']['error_msg'];
    } else {
      data = (response.data['response']!['items'] as List)
          .map((e) => Playlist.fromMap(e))
          .toList();
    }
    log('Loading user`s playlists.');
    return data;
  }

  Future<dynamic> getPlaylistMusic(Playlist playlist) async {
    final response = await method('audio.get',
        'owner_id=${playlist.ownerId}&album_id=${playlist.id}'
    );

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

  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete}) async {
    final User user = Hive.box('userBox').get('user');
    final audios = songsToDelete.map((e) => e.id).toList().join(',');
    method('audio.removeFromPlaylist', 'playlist_id=${playlist.id}&owner_id=${user.userId}&audio_ids=$audios');
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
        '${reorder == null ? '' : '&reorder_actions=$reorderFormat'}', isNew: true
    );

    return Playlist.fromMap(response.data['response']);
  }

  Future<dynamic> addAudiosToPlaylist(Playlist playlist, List<String> audiosToAdd) async {
    final User user = Hive.box('userBox').get('user');
    final response = await method('execute.addAudioToPlaylist',
        'owner_id=${user.userId}&playlist_id=${playlist.id}&audio_ids=${audiosToAdd.join(',')}');
    return Playlist.fromMap(response.data['response']['playlist']);
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
        .map((e) => Playlist.fromMap(e))
        .toList();
  }

  Future<dynamic> getRecommendations({int? offset}) async {
    final User user = Hive.box('userBox').get('user');
    final response = await method('audio.getRecommendations',
        'user_id=${user.userId}&count=20${offset == null ? '' : '&offset=$offset'}'
    );
    return (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(e))
        .toList();
  }
}

String _getRandomString(int lenght) {
  const chars =
      'QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm1234567890';
  return String.fromCharCodes(Iterable.generate(
      lenght, (_) => chars.codeUnitAt(math.Random().nextInt(chars.length))));
}