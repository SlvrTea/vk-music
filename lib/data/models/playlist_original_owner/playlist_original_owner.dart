
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_original_owner.freezed.dart';
part 'playlist_original_owner.g.dart';

@freezed
class PlaylistOriginalOwner with _$PlaylistOriginalOwner {
  const factory PlaylistOriginalOwner({
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'access_key') required String accessKey,
  }) = _PlaylistOriginalOwner;

  factory PlaylistOriginalOwner.fromJson(Map<String, dynamic> json) => _$PlaylistOriginalOwnerFromJson(json);
}
