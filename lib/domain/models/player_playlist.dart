
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/song.dart';

class PlayerPlaylist {
  PlayerPlaylist({required this.sources, required this.songs});

  final List<AudioSource> sources;
  final List<Song> songs;
}