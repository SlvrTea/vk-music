
import 'package:freezed_annotation/freezed_annotation.dart';

part 'thumb.freezed.dart';
part 'thumb.g.dart';

@freezed
class Thumb with _$Thumb {
  factory Thumb({
    required int width,
    required int height,
    @JsonKey(name: 'photo_34') String? photo34,
    @JsonKey(name: 'photo_68') String? photo68,
    @JsonKey(name: 'photo_135') String? photo135,
    @JsonKey(name: 'photo_270') String? photo270,
    @JsonKey(name: 'photo_300') String? photo300,
    @JsonKey(name: 'photo_600') String? photo600,
    @JsonKey(name: 'photo_1200') String? photo1200,
  }) = _Thumb;

  factory Thumb.fromJson(Map<String, dynamic> json) => _$ThumbFromJson(json);
}
