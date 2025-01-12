import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

import '../../../domain/model/player_playlist.dart';

class AudioPlayerController {
  AudioPlayerController() {
    _init();
  }

  final player = AudioPlayer();
  ConcatenatingAudioSource? _audioSource;

  Future<void> _init() async {
    await player.setAutomaticallyWaitsToMinimizeStalling(false);
  }

  Future<void> play(PlayerPlaylist playlist, {int? initialIndex}) async {
    _audioSource = ConcatenatingAudioSource(children: playlist.sources);
    try {
      await player.setAudioSource(_audioSource!, initialIndex: initialIndex);
      await player.seek(Duration.zero, index: initialIndex);

      await player.play();
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> pause() async => await player.pause();

  Future<void> resume() async => await player.play();

  Future<void> stop() async => await player.stop();

  Stream<Duration> getCurrentPos() => player.positionStream.cast();

  Stream<Duration> getCurrentBufferPos() => player.bufferedPositionStream.cast();

  Future<void> close() async => await player.dispose();
}
