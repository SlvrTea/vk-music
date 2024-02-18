import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/player_playlist.dart';

import '../../const.dart';
import '../../models/music_player.dart';
import '../../models/song.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  final MusicPlayer musicPlayer;
  late StreamSubscription playerStatusSubscription;
  late StreamSubscription playbackStream;

  MusicPlayerCubit({required this.musicPlayer})
      : super(MusicPlayerState()) {
    setLoopMode(getLoopMode());
    setShuffleModeEnabled(Hive.box('userBox').get('shuffle'));
    playerStatusSubscription = musicPlayer.player.playerStateStream.listen((event) {
      changePrecessingState(event.processingState);
    });
    playbackStream = musicPlayer.player.positionDiscontinuityStream.listen((event) {
        if (event.reason == PositionDiscontinuityReason.autoAdvance) _autoSeek(event.event.currentIndex!);
      },
      onError: (Object e, StackTrace stackTrace) => log('A stream error occurred: $e')
    );
  }

  void play({required Song song, PlayerPlaylist? playlist}) async {
    assert(playlist != null || state.playlist != null);

    if (playlist != null && playlist != state.playlist) {
      emit(state.copyWith(song: song, playlist: playlist, currentSongIndex: playlist.songs.indexOf(song)));
      await musicPlayer.play(playlist, initialIndex: playlist.songs.indexOf(song));
    } else if (musicPlayer.player.playing && song == state.song) {
      musicPlayer.pause();
      emit(state.copyWith(playStatus: PlayStatus.trackInPause));
    } else if (state.playStatus == PlayStatus.trackInPause && song == state.song) {
      musicPlayer.resume();
      emit(state.copyWith(playStatus: PlayStatus.trackPlaying));
    } else if (state.processingState == ProcessingState.ready) {
      seek(state.playlist!.songs.indexOf(song));
      emit(state.copyWith(song: song, playStatus: PlayStatus.trackPlaying));
      if (state.playStatus == PlayStatus.trackInPause) musicPlayer.resume();
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
      log('Seeking to $index');
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

  void setLoopMode(LoopMode mode) {
    log('Change loop mode to $mode');
    switch (mode) {
      case LoopMode.off:
        Hive.box('userBox').put('loopMode', 0);
      case LoopMode.all:
        Hive.box('userBox').put('loopMode', 1);
      case LoopMode.one:
        Hive.box('userBox').put('loopMode', 2);
    }
    musicPlayer.player.setLoopMode(mode);
  }

  void setShuffleModeEnabled(bool enabled) {
    log('Change shuffle mode to $enabled');
    Hive.box('userBox').put('shuffle', enabled);
    musicPlayer.player.setShuffleModeEnabled(enabled);
  }

  void changePrecessingState(ProcessingState value) => emit(state.copyWith(processingState: value));

  void stopOnComplete() {
    musicPlayer.stop();
    emit(state.copyWith(playStatus: PlayStatus.empty));
  }

  LoopMode getLoopMode() {
    switch (Hive.box('userBox').get('loopMode')) {
      case 0:
        return LoopMode.off;
      case 1:
        return LoopMode.all;
      case 3:
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
