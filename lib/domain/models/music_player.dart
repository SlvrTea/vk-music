
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vk_music/domain/models/player_playlist.dart';

import '../../data/vk_api/models/song.dart';

class MusicPlayer {
  final player = AudioPlayer();

  Future<void> playPlaylist(PlayerPlaylist playlist) async {
    player.setAudioSource(ConcatenatingAudioSource(children: playlist.sources));
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.play();
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> seek(duration) async {
    await player.seek(duration);
  }

  Stream getCurrentPos() {
    return player.positionStream.cast();
  }

  Stream getCurrentBufferPos() {
    return player.bufferedPositionStream.cast();
  }

  Stream onComplete() {
    return player.playerStateStream.cast();
  }

  Future<void> close() async {
    await player.dispose();
  }
}