import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

import '../../../domain/model/player_audio.dart';

abstract interface class IAudioBottomSheetModel extends ElementaryModel {
  ValueNotifier<List<PlayerAudio>?> get userAudiosNotifier;

  ListNotifier<PlayerAudio> get cachedAudiosNotifier;

  Future<void> addAudio(PlayerAudio audio);

  Future<void> deleteAudio(PlayerAudio audio);

  Future<void> addToPlaylist(Playlist playlist, PlayerAudio audio);

  Future<List<Playlist>> getPlaylists();

  Future<Playlist> getPlaylist(PlayerAudio audio);

  Future<void> cacheAudio(PlayerAudio audio);

  Future<void> deleteCachedAudio(PlayerAudio audio);
}

class AudioBottomSheetModel extends IAudioBottomSheetModel {
  AudioBottomSheetModel(this._audioRepository);

  @override
  ValueNotifier<List<PlayerAudio>?> get userAudiosNotifier => _audioRepository.userAudiosNotifier;

  @override
  ListNotifier<PlayerAudio> get cachedAudiosNotifier => _audioRepository.cachedAudioNotifier;

  final _logger = Logger(printer: PrettyPrinter(methodCount: 4));

  final AudioRepository _audioRepository;

  @override
  Future<void> addAudio(PlayerAudio audio) async {
    try {
      await _audioRepository.add(audio);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> deleteAudio(PlayerAudio audio) async {
    try {
      await _audioRepository.delete(audio);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> addToPlaylist(Playlist playlist, PlayerAudio audio) async {
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

  @override
  Future<Playlist> getPlaylist(PlayerAudio audio) async {
    try {
      final res = await _audioRepository.getPlaylistById(ownerId: audio.album!.ownerId, playlistId: audio.album!.id);
      return res;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }
  
  @override
  Future<void> cacheAudio(PlayerAudio audio) async {
    _audioRepository.downloadAudio(audio);
  }
  
  @override
  Future<void> deleteCachedAudio(PlayerAudio audio) async {
    _audioRepository.deleteCachedAudio(audio);
  }
}
