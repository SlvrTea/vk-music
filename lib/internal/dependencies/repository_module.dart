
import 'package:vk_music/data/repository/music_data_repository.dart';
import 'package:vk_music/data/service/vk_audio_service.dart';
import 'package:vk_music/domain/repository/music_repository.dart';

class RepositoryModule {
  static MusicRepository? _musicRepository;

  static MusicRepository musicRepository() {
    _musicRepository ??= MusicDataRepository(VKAudioService());
    return _musicRepository!;
  }
}