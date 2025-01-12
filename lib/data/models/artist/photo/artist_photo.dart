import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_photo.freezed.dart';
part 'artist_photo.g.dart';

@freezed
class ArtistPhoto with _$ArtistPhoto {
  const factory ArtistPhoto({
    required String url,
    required int width,
    required int height,
  }) = _ArtistPhoto;

  factory ArtistPhoto.fromJson(Map<String, dynamic> json) => _$ArtistPhotoFromJson(json);
}
