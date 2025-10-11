import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vk_music/data/models/artist/photo/artist_photo.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
abstract class Artist extends HiveObject with _$Artist {
  Artist._();

  factory Artist({
    required String name,
    String? domain,
    String? id,
    @Default([]) List<ArtistPhoto> photo,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
