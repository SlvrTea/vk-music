
import 'package:vk_music/data/repository/music_data_repository.dart';
import 'package:vk_music/data/service/vk_service.dart';
import 'package:vk_music/domain/repository/music_repository.dart';

class RepositoryModule {
  static MusicRepository? _musicRepository;

  static MusicRepository musicRepository() {
    _musicRepository ??= MusicDataRepository(VKService());
    return _musicRepository!;
  }
}