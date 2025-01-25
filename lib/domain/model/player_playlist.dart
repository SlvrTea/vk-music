import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/model/player_audio.dart';

class PlayerPlaylist extends ConcatenatingAudioSource {
  PlayerPlaylist({
    required List<PlayerAudio> children,
  }) : super(children: children.toList());
}
