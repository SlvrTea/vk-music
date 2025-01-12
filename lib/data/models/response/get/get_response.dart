import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vk_music/data/models/song/song.dart';

part 'get_response.freezed.dart';
part 'get_response.g.dart';

@freezed
class GetResponse with _$GetResponse {
  const factory GetResponse({
    int? count,
    required List<Song> items,
  }) = _GetResponse;

  factory GetResponse.fromJson(Map<String, dynamic> json) => _$GetResponseFromJson(json);
}
