import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

import '../../../data/models/song/song.dart';
import '../../../domain/audio/audio_repository.dart';

abstract interface class IAudioScreenModel extends ElementaryModel {
  ValueNotifier<List<Song>?> get userAudiosNotifier;

  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier;

  Future<List<Playlist>> getPlaylists({int? count, int? offset});

  Future<List<Song>> getAudios(String ownerId);
}

class AudioScreenModel extends IAudioScreenModel {
  AudioScreenModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  ValueNotifier<List<Song>?> get userAudiosNotifier => _audioRepository.userAudiosNotifier;

  @override
  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier => _audioRepository.userAlbumsNotifier;

  @override
  Future<List<Playlist>> getPlaylists({int? count, int? offset}) async {
    final res = await _audioRepository.getPlaylists(count: count, offset: offset);
    return res.items;
  }

  @override
  Future<List<Song>> getAudios(String ownerId) async {
    final res = await _audioRepository.getAudios(ownerId: ownerId, isUserAudios: true);
    return res.items;
  }
}
