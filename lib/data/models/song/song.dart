import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/song/song_album/song_album.dart';

import '../artist/artist.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  factory Song({
    required String artist,
    required int id,
    @JsonKey(name: 'owner_id') required int ownerId,
    required String title,
    required int duration,
    @JsonKey(name: 'access_key') required String accessKey,
    required String url,
    SongAlbum? album,
    @JsonKey(name: 'release_audio_id') String? releaseAudioId,
    @JsonKey(name: 'main_artists') List<Artist>? mainArtists,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
