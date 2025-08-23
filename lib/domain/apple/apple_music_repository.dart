
import 'package:vk_music/data/provider/apple/apple_music_service.dart';

class AppleMusicRepository {
  const AppleMusicRepository(this._appleMusicService); 

  final AppleMusicService _appleMusicService;

  Future<void> search(String title, String artist) async {
    final t = title.replaceAll(' ', '+') + artist.replaceAll(' ', '+');
    _appleMusicService.search(title: t);
  }
}