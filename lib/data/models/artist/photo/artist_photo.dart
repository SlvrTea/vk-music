import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'artist_photo.freezed.dart';
part 'artist_photo.g.dart';

@freezed
abstract class ArtistPhoto extends HiveObject with _$ArtistPhoto {
  ArtistPhoto._();

  factory ArtistPhoto({
    required String url,
    required int width,
    required int height,
  }) = _ArtistPhoto;

  factory ArtistPhoto.fromJson(Map<String, dynamic> json) => _$ArtistPhotoFromJson(json);
}
