import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/playlist_original_owner/playlist_original_owner.dart';
import 'package:vk_music/data/models/thumb/thumb.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

@freezed
class Playlist with _$Playlist {
  factory Playlist({
    required int id,
    required int ownerId,
    required int type,
    required String title,
    required String description,
    required int count,
    required int followers,
    required int plays,
    required int createTime,
    required int updateTime,
    required bool isFollowing,
    required String accessKey,
    required String albumType,
    required bool exclusive,
    PlaylistOriginalOwner? original,
    List<Thumb>? thumbs,
    Thumb? photo,
    String? mainColor,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);
}
