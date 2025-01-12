import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

part 'search_albums_response.freezed.dart';
part 'search_albums_response.g.dart';

@freezed
class SearchAlbumsResponse with _$SearchAlbumsResponse {
  const factory SearchAlbumsResponse({
    required int count,
    required List<Playlist> items,
  }) = _SearchAlbumsResponse;

  factory SearchAlbumsResponse.fromJson(Map<String, dynamic> json) => _$SearchAlbumsResponseFromJson(json);
}
