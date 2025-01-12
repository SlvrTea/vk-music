import 'package:freezed_annotation/freezed_annotation.dart';

import '../../song/song.dart';

part 'get_recommendations_response.freezed.dart';
part 'get_recommendations_response.g.dart';

@freezed
class GetRecommendationsResponse with _$GetRecommendationsResponse {
  const factory GetRecommendationsResponse({
    required List<Song> items,
}) = _GetRecommendationsResponse;

  factory GetRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$GetRecommendationsResponseFromJson(json);
}
