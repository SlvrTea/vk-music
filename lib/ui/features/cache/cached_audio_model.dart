import 'package:elementary/elementary.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';
import 'package:vk_music/domain/model/player_audio.dart';

abstract interface class ICachedAudioModel extends ElementaryModel {
  ListNotifier<PlayerAudio> get cachedAudioNotifier;
}

class CachedAudioModel extends ICachedAudioModel {
  CachedAudioModel({required AudioRepository audioRepository}) : _audioRepository = audioRepository;

  final AudioRepository _audioRepository;

  @override
  ListNotifier<PlayerAudio> get cachedAudioNotifier => _audioRepository.cachedAudioNotifier;
}
