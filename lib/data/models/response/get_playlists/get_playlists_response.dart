
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../playlist/playlist.dart';

part 'get_playlists_response.freezed.dart';
part 'get_playlists_response.g.dart';

@freezed
class GetPlaylistsResponse with _$GetPlaylistsResponse {
  factory GetPlaylistsResponse({
    required int count,
    required List<Playlist> items,
  }) = _GetPlaylistsResponse;

  factory GetPlaylistsResponse.fromJson(Map<String, dynamic> json) => _$GetPlaylistsResponseFromJson(json);
}