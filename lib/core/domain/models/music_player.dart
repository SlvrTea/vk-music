import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/core/domain/models/player_playlist.dart';

class MusicPlayer {
  final player = AudioPlayer();
  ConcatenatingAudioSource? _audioSource;

  // Add constructor to initialize player settings
  MusicPlayer() {
    _initPlayer();
  }

  // Add initialization method
  Future<void> _initPlayer() async {
    await player.setAutomaticallyWaitsToMinimizeStalling(false);
  }

  Future<void> play(PlayerPlaylist playlist, {int? initialIndex}) async {
    try {
      // Add error handling
      if (_audioSource == null) {
        _audioSource = ConcatenatingAudioSource(children: playlist.sources);
        await player.setAudioSource(_audioSource!, initialIndex: initialIndex);
      } else if (_audioSource != null) {
        await _audioSource!.clear();
        await _audioSource!.addAll(playlist.sources);
        await player.seek(Duration.zero, index: initialIndex);
      }
      await player.play();
    } catch (e) {
      print("Playback error: $e");
      rethrow; // Optional: rethrow if you want to handle errors elsewhere
    }
  }

  // Rest of your code stays the same
  Future<void> pause() async => await player.pause();
  Future<void> resume() async => await player.play();
  Future<void> stop() async => await player.stop();
  Stream<Duration> getCurrentPos() => player.positionStream.cast();
  Stream<Duration> getCurrentBufferPos() =>
      player.bufferedPositionStream.cast();
  Future<void> close() async => await player.dispose();
}
