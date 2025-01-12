
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

part 'search_playlists_response.freezed.dart';
part 'search_playlists_response.g.dart';


@freezed
class SearchPlaylistsResponse with _$SearchPlaylistsResponse {
  const factory SearchPlaylistsResponse({
    required int count,
    required List<Playlist> items,
  }) = _SearchPlaylistsResponse;

  factory SearchPlaylistsResponse.fromJson(Map<String, dynamic> json) => _$SearchPlaylistsResponseFromJson(json);
}
