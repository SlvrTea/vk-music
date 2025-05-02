import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/domain/model/custom_shuffle_order.dart';
import 'package:vk_music/domain/model/player_audio.dart';

import '../../../domain/model/player_playlist.dart';

class AppAudioPlayer extends AudioPlayer {
  AppAudioPlayer() {
    setAutomaticallyWaitsToMinimizeStalling(false);

    setLoopMode(_getLoopMode());
    setShuffleModeEnabled(_getShuffle());

    _playbackStreamSubscription = playbackEventStream.listen((event) {
      currentIndexNotifier.value = event.currentIndex;
      processingStateNotifier.value = event.processingState;
      if (event.currentIndex != null && audioSource != null) {
        currentAudioNotifier.value =
            (audioSource as ConcatenatingAudioSource).children[event.currentIndex!] as PlayerAudio;
      }
      if (event.processingState == ProcessingState.completed && nextIndex == null) {
        currentAudioNotifier.value = null;
        currentIndexNotifier.value = null;
        isPlaying.value = false;
      }
      if (event.processingState == ProcessingState.idle && playing == false) {
        currentAudioNotifier.value = null;
        currentIndexNotifier.value = null;
        isPlaying.value = false;
      }
    });

    _playerStateStreamSubscription = playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  @override
  PlayerPlaylist? get audioSource => currentPlaylist.value;

  final ValueNotifier<int?> currentIndexNotifier = ValueNotifier(null);
  final ValueNotifier<bool?> isPlaying = ValueNotifier(null);
  final ValueNotifier<ProcessingState?> processingStateNotifier = ValueNotifier(null);
  final ValueNotifier<PlayerAudio?> currentAudioNotifier = ValueNotifier(null);
  final ValueNotifier<PlayerPlaylist?> currentPlaylist = ValueNotifier(null);

  late final StreamSubscription<PlaybackEvent?> _playbackStreamSubscription;
  late final StreamSubscription<PlayerState?> _playerStateStreamSubscription;

  final _logger = Logger();

  Future<void> playFrom({required PlayerPlaylist playlist, int? initialIndex}) async {
    try {
      if (initialIndex != null) {
        if (playerState.playing &&
            initialIndex == currentIndex &&
            playlist.children[initialIndex] == currentAudioNotifier.value) {
          return pause();
        }
        if (!playerState.playing &&
            initialIndex == currentIndex &&
            playlist.children[initialIndex] == currentAudioNotifier.value) {
          return play();
        }
      }
      currentPlaylist.value = playlist;
      await setAudioSource(playlist, initialIndex: initialIndex, initialPosition: Duration.zero);
      await play();
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  Future<void> move(int currentIndex, int newIndex) async {
    try {
      if (audioSource == null) return;
      await audioSource!.move(currentIndex, newIndex > currentIndex ? newIndex - 1 : newIndex);
      currentPlaylist.value = PlayerPlaylist(children: audioSource!.children as List<PlayerAudio>);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  Future<void> moveShuffle(int currentIndex, int newIndex) async {
    try {
      if (audioSource == null) return;
      final playlist = audioSource;
      //playlist.shuffleIndices.insert(newIndex, playlist.shuffleIndices.removeAt(currentIndex));
      CustomShuffleOrder.pendingMove = (currentIndex, newIndex);
      shuffle();
      currentPlaylist.value = playlist;
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  Future<void> playNext(PlayerAudio audio) async {
    try {
      if (currentPlaylist.value == null) {
        final playlist = PlayerPlaylist(children: [audio]);
        playFrom(playlist: playlist);
        return;
      }

      final index = currentPlaylist.value!.children.indexOf(audio);
      if (nextIndex != null && index != -1) {
        await move(index, nextIndex!);
      } else {
        await audioSource!.add(audio);
        if (nextIndex != null) {
          await audioSource!.move((audioSource!.children.length - 1), nextIndex!);
        }
      }
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> dispose() {
    _playbackStreamSubscription.cancel();
    _playerStateStreamSubscription.cancel();
    return super.dispose();
  }

  void switchShuffleMode() {
    final mode = !_getShuffle();
    Hive.box('userBox').put('shuffle', mode);
    setShuffleModeEnabled(mode);
  }

  void switchLoopMode(LoopMode mode) async {
    switch (mode) {
      case LoopMode.off:
        Hive.box('userBox').put('loopMode', 0);
      case LoopMode.all:
        Hive.box('userBox').put('loopMode', 1);
      case LoopMode.one:
        Hive.box('userBox').put('loopMode', 2);
    }
    await setLoopMode(mode);
  }

  bool _getShuffle() => Hive.box('userBox').get('shuffle') ?? false;

  LoopMode _getLoopMode() {
    switch (Hive.box('userBox').get('loopMode')) {
      case 0:
        return LoopMode.off;
      case 1:
        return LoopMode.all;
      case 2:
        return LoopMode.one;
      default:
        return LoopMode.off;
    }
  }
}
