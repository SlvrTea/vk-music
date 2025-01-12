import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/artist/photo/artist_photo.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    required String name,
    String? domain,
    String? id,
    @Default([]) List<ArtistPhoto> photo,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
