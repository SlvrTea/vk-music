
import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/player_playlist.dart';

class MusicPlayer {
  final player = AudioPlayer();
  ConcatenatingAudioSource? _audioSource;

  Future<void> play(PlayerPlaylist playlist, {int? initialIndex}) async {
    if (_audioSource == null) {
      _audioSource = ConcatenatingAudioSource(children: playlist.sources);
      player.setAudioSource(_audioSource!, initialIndex: initialIndex);
    } else if (_audioSource != null) {
      await _audioSource!.clear();
      await _audioSource!.addAll(playlist.sources);
      await player.seek(Duration.zero, index: initialIndex);
    }
    await player.play();
  }

  Future<void> pause() async => await player.pause();

  Future<void> resume() async => await player.play();

  Future<void> stop() async => await player.stop();

  Stream<Duration> getCurrentPos() => player.positionStream.cast();

  Stream<Duration> getCurrentBufferPos() => player.bufferedPositionStream.cast();

  Future<void> close() async => await player.dispose();
}