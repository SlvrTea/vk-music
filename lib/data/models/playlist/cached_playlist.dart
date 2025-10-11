import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vk_music/domain/model/player_audio.dart';

class CachedPlaylist extends HiveObject {
  final int id;
  final String? thumb;
  final String name;
  final List<PlayerAudio> audios;

  CachedPlaylist({this.thumb, required this.audios, required this.name, required this.id});
}
