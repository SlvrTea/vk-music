import 'package:freezed_annotation/freezed_annotation.dart';

import '../../thumb/thumb.dart';

part 'song_album.freezed.dart';
part 'song_album.g.dart';

@freezed
class SongAlbum with _$SongAlbum {
  factory SongAlbum({
    required int id,
    required String title,
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'access_key') required String accessKey,
    Thumb? thumb,
  }) = _SongAlbum;

  factory SongAlbum.fromJson(Map<String, dynamic> json) => _$SongAlbumFromJson(json);
}
