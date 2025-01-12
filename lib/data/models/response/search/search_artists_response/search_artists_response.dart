import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/artist/artist.dart';

part 'search_artists_response.freezed.dart';
part 'search_artists_response.g.dart';

@freezed
class SearchArtistsResponse with _$SearchArtistsResponse {
  const factory SearchArtistsResponse({
    required int count,
    @Default([]) List<Artist> items,
  }) = _SearchArtistsResponse;

  factory SearchArtistsResponse.fromJson(Map<String, dynamic> json) => _$SearchArtistsResponseFromJson(json);
}
