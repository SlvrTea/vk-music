
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/player_playlist.dart';

class MusicPlayer {
  final player = AudioPlayer();

  Future<void> playPlaylist(PlayerPlaylist playlist, {int? initialIndex}) async {
    player.setAudioSource(ConcatenatingAudioSource(children: playlist.sources), initialIndex: initialIndex);
    await player.play();
  }

  Future<void> pause() async => await player.pause();

  Future<void> resume() async => await player.play();

  Future<void> stop() async => await player.stop();

  Future<void> seek(Duration? duration, {int? index}) async => await player.seek(duration, index: index);

  Stream<Duration> getCurrentPos() => player.positionStream.cast();

  Stream<Duration> getCurrentBufferPos() => player.bufferedPositionStream.cast();

  Stream<PlayerState> onComplete() => player.playerStateStream.cast();

  Stream<int?> currentIndex() => player.currentIndexStream.cast();

  Future<void> close() async => await player.dispose();
}