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
  late StreamSubscription currentIndexSubscription;

  MusicPlayerCubit({required this.musicPlayer})
      : super(MusicPlayerState()) {
    setLoopMode(getLoopMode());
    setShuffleModeEnabled(Hive.box('userBox').get('shuffle'));
    playerStatusSubscription = musicPlayer.player.playerStateStream.listen((event) {
      changePrecessingState(event.processingState);
    });
    currentIndexSubscription = musicPlayer.player.currentIndexStream.cast().listen((event) {
      if (event != null && state.playlist != null && state.song != null) {
        if (event != state.playlist!.songs.indexOf(state.song!)) seek(event);
      }
    });
  }

  void playMusic({required Song song, PlayerPlaylist? playlist}) {
    if (playlist != null && state.playlist == null) {
      emit(state.copyWith(playlist: playlist));
      musicPlayer.player.setAudioSource(ConcatenatingAudioSource(children: playlist.sources));
    }
    if (musicPlayer.player.playing && song == state.song && state.processingState != ProcessingState.loading) {
      musicPlayer.pause();
      emit(state.copyWith(playStatus: PlayStatus.trackInPause));
    } else if (state.playStatus == PlayStatus.trackInPause && song == state.song) {
      musicPlayer.resume();
      emit(state.copyWith(playStatus: PlayStatus.trackPlaying));
    } else if (state.processingState == ProcessingState.ready && state.playlist!.songs.contains(song)) {
      emit(state.copyWith(song: song, playStatus: PlayStatus.trackPlaying));
      seek(state.playlist!.songs.indexOf(song));
    } else {
      emit(state.copyWith(song: song, playlist: playlist, playStatus: PlayStatus.trackPlaying));
      musicPlayer.play(state.playlist!, initialIndex: state.playlist!.songs.indexOf(song));
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
    log('Seeking to $index');
    emit(state.copyWith(song: state.playlist!.songs[index]));
    musicPlayer.seek(Duration.zero, index: index);
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
    currentIndexSubscription.cancel();
    playerStatusSubscription.cancel();
    return super.close();
  }
}
