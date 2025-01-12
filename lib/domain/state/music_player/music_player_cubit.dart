import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/common/utils/audio_player/audio_player_controller.dart';

import '../../../data/models/song/song.dart';
import '../../enum/play_status.dart';
import '../../model/player_playlist.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  final AudioPlayerController musicPlayer;
  late final StreamSubscription playerStatusSubscription;
  late final StreamSubscription playbackStream;

  final _logger = Logger(printer: PrettyPrinter(methodCount: 1));

  MusicPlayerCubit({required this.musicPlayer}) : super(MusicPlayerState()) {
    setLoopMode(getLoopMode());
    musicPlayer.player.setShuffleModeEnabled(getShuffle());

    playerStatusSubscription = musicPlayer.player.playerStateStream.listen((event) {
      emit(state.copyWith(isPlaying: event.playing));
      changePrecessingState(event.processingState);
      if (event.processingState == ProcessingState.completed) {
        emit(MusicPlayerState(
          playStatus: PlayStatus.empty,
          song: null,
        ));
      }
    });

    playbackStream = musicPlayer.player.positionDiscontinuityStream.listen((event) {
      if (event.reason == PositionDiscontinuityReason.autoAdvance) _autoSeek(event.event.currentIndex!);
      emit(state.copyWith(currentSongIndex: event.event.currentIndex));
    });
  }

  void play({required Song song, PlayerPlaylist? playlist}) async {
    assert(playlist != null || state.playlist != null);

    if ((state.isPlaying ?? false) && song.id == state.song?.id) {
      _logger.i('Pause track');
      musicPlayer.pause();
      emit(state.copyWith(
        playStatus: PlayStatus.trackInPause,
      ));
    } else if (state.playStatus == PlayStatus.trackInPause && song.id == state.song!.id) {
      _logger.i('Resume track');
      musicPlayer.resume();
      emit(state.copyWith(playStatus: PlayStatus.trackPlaying));
    } else if (playlist != null && playlist != state.playlist) {
      _logger.i('Playing track: ${song.title}');
      emit(state.copyWith(
        song: song,
        playlist: playlist,
        currentSongIndex: playlist.songs.indexOf(song),
        playStatus: PlayStatus.trackPlaying,
      ));
      await musicPlayer.play(playlist, initialIndex: playlist.songs.indexOf(song));
    } else if (state.processingState == ProcessingState.ready) {
      seek(state.playlist!.songs.indexOf(song));
      emit(state.copyWith(song: song, playStatus: PlayStatus.trackPlaying));
    }
  }

  void seekToNext() {
    assert(state.playlist != null);
    emit(state.copyWith(song: state.playlist!.songs[musicPlayer.player.nextIndex!]));
    musicPlayer.player.seekToNext();
  }

  void seekToPrevious() {
    assert(state.playlist != null);
    emit(state.copyWith(song: state.playlist!.songs[musicPlayer.player.previousIndex!]));
    musicPlayer.player.seekToPrevious();
  }

  void seek(int index) {
    assert(state.playlist != null);
    if (index != state.currentSongIndex) {
      emit(state.copyWith(song: state.playlist!.songs[index], currentSongIndex: index));
      musicPlayer.player.seek(Duration.zero, index: index);
    }
  }

  void _autoSeek(int index) {
    assert(state.playlist != null);
    if (index == musicPlayer.player.nextIndex) {
      emit(state.copyWith(song: state.playlist!.songs[index], currentSongIndex: index));
    }
  }

  void setLoopMode(LoopMode mode) async {
    switch (mode) {
      case LoopMode.off:
        Hive.box('userBox').put('loopMode', 0);
      case LoopMode.all:
        Hive.box('userBox').put('loopMode', 1);
      case LoopMode.one:
        Hive.box('userBox').put('loopMode', 2);
    }
    await musicPlayer.player.setLoopMode(mode);
  }

  void switchShuffleMode() {
    final mode = !getShuffle();
    Hive.box('userBox').put('shuffle', mode);
    musicPlayer.player.setShuffleModeEnabled(mode);
  }

  void changePrecessingState(ProcessingState value) => emit(state.copyWith(processingState: value));

  void stopOnComplete() {
    musicPlayer.stop();
    emit(state.copyWith(playStatus: PlayStatus.empty));
  }

  bool getShuffle() => Hive.box('userBox').get('shuffle') ?? false;

  LoopMode getLoopMode() {
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

  @override
  Future<void> close() {
    musicPlayer.close();
    playbackStream.cancel();
    playerStatusSubscription.cancel();
    return super.close();
  }
}
