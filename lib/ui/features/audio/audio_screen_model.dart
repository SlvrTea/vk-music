import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

import '../../../domain/audio/audio_repository.dart';
import '../../../domain/model/player_audio.dart';

abstract interface class IAudioScreenModel extends ElementaryModel {
  ValueNotifier<List<PlayerAudio>?> get userAudiosNotifier;

  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier;

  ListNotifier<PlayerAudio> get cachedAudioNotifier;

  Future<List<Playlist>> getPlaylists({int? count, int? offset});

  Future<List<PlayerAudio>> getAudios(String ownerId);

  Future<void> reorder({required int audioId, int? before, int? after});

  void loadCachedAudio();
}

class AudioScreenModel extends IAudioScreenModel {
  AudioScreenModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  ValueNotifier<List<PlayerAudio>?> get userAudiosNotifier => _audioRepository.userAudiosNotifier;

  @override
  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier => _audioRepository.userAlbumsNotifier;

  @override
  ListNotifier<PlayerAudio> get cachedAudioNotifier => _audioRepository.cachedAudioNotifier;

  @override
  Future<List<Playlist>> getPlaylists({int? count, int? offset}) async {
    final res = await _audioRepository.getPlaylists(count: count, offset: offset);
    return res.items;
  }

  @override
  Future<List<PlayerAudio>> getAudios(String ownerId) async {
    final res = await _audioRepository.getAudios(ownerId: ownerId, isUserAudios: true);
    return res.items;
  }

  @override
  Future<void> reorder({required int audioId, int? before, int? after}) async {
    try {
      await _audioRepository.reorder(audioId: audioId, before: before, after: after);
    } on Exception catch (e) {
      rethrow;
    }
  }
  
  @override
  void loadCachedAudio() {
    _audioRepository.loadCachedAudio();
  }
}
