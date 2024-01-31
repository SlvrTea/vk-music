import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/player_playlist.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/vk_api.dart';
import '../../const.dart';
import '../../models/music_player.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  final MusicPlayer musicPlayer;
  final VKApi vkApi;
  late StreamSubscription playerStatusSubscription;

  MusicPlayerCubit({required this.musicPlayer, required this.vkApi})
      : super(MusicPlayerState()) {
    playerStatusSubscription = musicPlayer.onComplete().listen((event) {
      switch (event.processingState) {
        case ProcessingState.idle:
          changePrecessingState(ProcessingState.idle);
        case ProcessingState.loading:
          changePrecessingState(ProcessingState.loading);
        case ProcessingState.ready:
          changePrecessingState(ProcessingState.ready);
      }
    });
  }

  void playMusic({Song? song, PlayerPlaylist? playlist}) {
    if (playlist != state.playlist) emit(state.copyWith(playlist: playlist));
    if (musicPlayer.player.playing && song == state.song && state.processingState != ProcessingState.loading) {
      musicPlayer.pause();
      emit(state.copyWith(playStatus: PlayStatus.trackInPause));
    } else if (state.playStatus == PlayStatus.trackInPause && song == state.song) {
      musicPlayer.resume();
      emit(state.copyWith(playStatus: PlayStatus.trackPlaying));
    } else {
      emit(state.copyWith(song: song, playStatus: PlayStatus.trackPlaying));
      seek(playlist!.songs.indexOf(song!));
      musicPlayer.playPlaylist(state.playlist!);
    }
  }

  void seekToNext() {
    assert(state.playlist != null);
    emit(state.copyWith(song: state.playlist!.songs[musicPlayer.player.currentIndex! + 1]));
    musicPlayer.player.seekToNext();
  }

  void seekToPrevious() {
    assert(state.playlist != null);
    emit(state.copyWith(song: state.playlist!.songs[musicPlayer.player.currentIndex! - 1]));
    musicPlayer.player.seekToPrevious();
  }

  void seek(int index) {
    assert(state.playlist != null);
    emit(state.copyWith(song: state.playlist!.songs[index]));
    musicPlayer.player.seek(Duration.zero, index: index);
  }

  void setLoopMode(LoopMode mode) {
    assert(state.playlist != null);
    musicPlayer.player.setLoopMode(mode);
  }

  void setShuffleModeEnabled(bool enabled) {
    assert(state.playlist != null);
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
    playerStatusSubscription.cancel();
    return super.close();
  }
}
