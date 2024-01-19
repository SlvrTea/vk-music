
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../data/vk_api/models/song.dart';

class MusicPlayer {
  final player = AudioPlayer();

  Future<void> play({required Song song}) async {
    await player.setAudioSource(AudioSource.uri(
      song.online ? Uri.parse(song.url!) : Uri.file(song.url!),
      tag: MediaItem(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist,
        artUri: song.photoUrl68 != null ? Uri.tryParse(song.photoUrl68!) : null
      )
    ));
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