import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

import '../../../data/models/song/song.dart';

abstract interface class IAudioBottomSheetModel extends ElementaryModel {
  ValueNotifier<List<Song>?> get userAudiosNotifier;

  Future<void> addAudio(Song audio);

  Future<void> deleteAudio(Song audio);

  Future<void> addToPlaylist(Playlist playlist, Song audio);

  Future<List<Playlist>> getPlaylists();
}

class AudioBottomSheetModel extends IAudioBottomSheetModel {
  AudioBottomSheetModel(this._audioRepository);

  @override
  ValueNotifier<List<Song>?> get userAudiosNotifier => _audioRepository.userAudiosNotifier;

  final _logger = Logger();

  final AudioRepository _audioRepository;

  @override
  Future<void> addAudio(Song audio) async {
    try {
      await _audioRepository.add(audio);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> deleteAudio(Song audio) async {
    try {
      await _audioRepository.delete(audio);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> addToPlaylist(Playlist playlist, Song audio) async {
    try {
      await _audioRepository.addToPlaylist(playlist, [audio]);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<List<Playlist>> getPlaylists() async {
    try {
      final res = await _audioRepository.getPlaylists();
      return res.items;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }
}
