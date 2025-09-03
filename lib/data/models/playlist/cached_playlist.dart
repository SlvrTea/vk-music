import 'package:vk_music/domain/model/player_audio.dart';

class CachedPlaylist {
  final String thumb;
  final List<PlayerAudio> audios;

  CachedPlaylist({required this.thumb, required this.audios});
}
