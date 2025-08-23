import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'apple_music_service.g.dart';

@RestApi()
abstract class AppleMusicService {
  factory AppleMusicService(Dio dio, {String? baseUrl}) = _AppleMusicService;

  @GET('catalog/us/search')
  Future<void> search({@Query('term') required String title});
}
