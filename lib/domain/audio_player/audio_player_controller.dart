import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' show Hive;
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/domain/model/player_audio.dart';

class AppAudioPlayer extends AudioPlayer {
  @override
  List<PlayerAudio> get audioSources => _audioSources;
  List<PlayerAudio> _audioSources = [];

  @override
  Future<Duration?> setAudioSources(
    List<AudioSource> audioSources, {
    bool preload = true,
    int? initialIndex,
    Duration? initialPosition,
    ShuffleOrder? shuffleOrder,
  }) async {
    assert(audioSources is List<PlayerAudio>);
    _audioSources = [...audioSources as List<PlayerAudio>];
    return super.setAudioSources(
      audioSources,
      preload: preload,
      initialIndex: initialIndex,
      initialPosition: initialPosition,
      shuffleOrder: shuffleOrder,
    );
  }
}

class AppAudioPlayerController with ChangeNotifier {
  AppAudioPlayerController(AppConfig config) {
    _playbackStreamSubscription = _player.playbackEventStream.listen(
      _listenPlaybackEvent,
    );
    _playerStateStreamSubscription = _player.playerStateStream.listen(
      _listenPlayerState,
    );

    _player
      ..setAutomaticallyWaitsToMinimizeStalling(false)
      ..setLoopMode(config.loopMode)
      ..setShuffleModeEnabled(config.enableShuffle);
  }

  LoopMode get loopMode => _player.loopMode;

  bool get shuffleModeEnabled => _player.shuffleModeEnabled;

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  List<int> get shuffleIndices => _player.shuffleIndices;

  final _player = AppAudioPlayer();

  late final StreamSubscription<PlaybackEvent?> _playbackStreamSubscription;
  late final StreamSubscription<PlayerState?> _playerStateStreamSubscription;

  int? currentIndex;
  bool? playing;
  ProcessingState? state;
  PlayerAudio? currentAudio;
  List<PlayerAudio>? currentPlaylist;

  @override
  void dispose() {
    _playbackStreamSubscription.cancel();
    _playerStateStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> seekToNext() => _player.seekToNext();

  Future<void> seekToPrevious() => _player.seekToPrevious();

  Future<void> seek(Duration position, {int? index}) =>
      _player.seek(position, index: index);

  Future<void> playFrom({
    required List<PlayerAudio> playlist,
    int? initialIndex,
  }) async {
    if (initialIndex != null) {
      if (_player.playerState.playing &&
          initialIndex == currentIndex &&
          playlist[initialIndex] == currentAudio) {
        await _player.pause();
        return notifyListeners();
      } else if (!_player.playerState.playing &&
          initialIndex == currentIndex &&
          playlist[initialIndex] == currentAudio) {
        await _player.play();
        return notifyListeners();
      }
    }

    if (const ListEquality().equals(currentPlaylist, playlist)) {
      _player.seek(Duration.zero, index: initialIndex);
      await _player.play();
      return notifyListeners();
    }
    if (playing ?? false) {
      await _player.stop();
    }
    currentPlaylist = [...playlist];
    await _player.setAudioSources(
      playlist,
      initialIndex: initialIndex,
      initialPosition: Duration.zero,
    );
    await _player.play();
    return notifyListeners();
  }

  Future<void> move(int currentIndex, int newIndex) async {
    if (_player.shuffleModeEnabled) {
      _player.shuffleIndices.insert(
        newIndex > currentIndex ? newIndex - 1 : newIndex,
        _player.shuffleIndices.removeAt(currentIndex),
      );
      return notifyListeners();
    }
    currentPlaylist!.insert(
      newIndex > currentIndex ? newIndex - 1 : newIndex,
      currentPlaylist!.removeAt(currentIndex),
    );
    notifyListeners();
    await _player.moveAudioSource(
      currentIndex,
      newIndex > currentIndex ? newIndex - 1 : newIndex,
    );
  }

  Future<void> playNext(PlayerAudio audio) async {
    if (currentPlaylist == null) {
      return playFrom(playlist: [audio]);
    }

    final index = currentPlaylist!.indexOf(audio);
    if (_player.nextIndex != null && index != -1) {
      return await move(index, _player.nextIndex!);
    } else if (_player.nextIndex == null) {
      currentPlaylist!.add(audio);
      _player.addAudioSource(audio);
      return notifyListeners();
    } else if (index == -1 && _player.nextIndex != null) {
      _player.insertAudioSource(_player.nextIndex!, audio);
      currentPlaylist!.insert(_player.nextIndex!, audio);
      return notifyListeners();
    } else {
      currentPlaylist!.swap(currentPlaylist!.length - 1, _player.nextIndex!);
      _player.moveAudioSource(currentPlaylist!.length - 1, _player.nextIndex!);
      return notifyListeners();
    }
  }

  Future<void> switchShuffleMode() async {
    final box = Hive.box<AppConfig>('config');
    final mode = !_getShuffle();
    box.put('main', box.get('main')!.copyWith(enableShuffle: mode));
    await _player.setShuffleModeEnabled(mode);
    if (mode) _player.shuffle();
    notifyListeners();
  }

  void setShuffleModeEnabled(bool enabled) =>
      _player.setShuffleModeEnabled(enabled);

  void switchLoopMode(LoopMode mode) async {
    final box = Hive.box<AppConfig>('config');
    switch (mode) {
      case LoopMode.off:
        box.put('main', box.get('main')!.copyWith(loopMode: mode));
      case LoopMode.all:
        box.put('main', box.get('main')!.copyWith(loopMode: mode));
      case LoopMode.one:
        box.put('main', box.get('main')!.copyWith(loopMode: mode));
    }
    await _player.setLoopMode(mode);
    notifyListeners();
  }

  void _listenPlaybackEvent(PlaybackEvent event) {
    currentIndex = event.currentIndex;
    state = event.processingState;
    if (event.currentIndex != null &&
        currentPlaylist != null &&
        (currentPlaylist?.isNotEmpty ?? false)) {
      currentAudio = currentPlaylist![event.currentIndex!];
    }
    if (event.processingState == ProcessingState.completed &&
        _player.nextIndex == null) {
      currentAudio = null;
      currentIndex = null;
      playing = false;
    }
    if (event.processingState == ProcessingState.idle && playing == false) {
      currentAudio = null;
      currentIndex = null;
      playing = false;
    }

    notifyListeners();
  }

  void _listenPlayerState(PlayerState state) {
    playing = state.playing;
    notifyListeners();
  }

  bool _getShuffle() =>
      Hive.box<AppConfig>('config').get('main')?.enableShuffle ?? false;
}
