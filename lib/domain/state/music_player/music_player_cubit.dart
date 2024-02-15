import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
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
    playerStatusSubscription = musicPlayer.player.playerStateStream.listen((event) {
      changePrecessingState(event.processingState);
    });
    currentIndexSubscription = musicPlayer.player.currentIndexStream.listen((event) {
      if (event != null && state.playlist != null && event != musicPlayer.player.currentIndex) {
        seek(musicPlayer.player.currentIndex!);
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
      emit(state.copyWith(song: song, playlist: playlist!, playStatus: PlayStatus.trackPlaying));
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
    assert(state.playlist != null);
    log('Change loop mode to $mode');
    musicPlayer.player.setLoopMode(mode);
  }

  void setShuffleModeEnabled(bool enabled) {
    assert(state.playlist != null);
    log('Change shuffle mode to $enabled');
    musicPlayer.player.setShuffleModeEnabled(enabled);
  }

  void changePrecessingState(ProcessingState value) => emit(state.copyWith(processingState: value));

  void stopOnComplete() {
    musicPlayer.stop();
    emit(state.copyWith(playStatus: PlayStatus.empty));
  }

  @override
  Future<void> close() {
    musicPlayer.close();
    currentIndexSubscription.cancel();
    playerStatusSubscription.cancel();
    return super.close();
  }
}
