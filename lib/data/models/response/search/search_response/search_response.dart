import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/domain/model/player_audio.dart';

part 'search_response.freezed.dart';
part 'search_response.g.dart';

@freezed
class SearchResponse with _$SearchResponse {
  factory SearchResponse({
    required int count,
    required List<PlayerAudio> items,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);
}
