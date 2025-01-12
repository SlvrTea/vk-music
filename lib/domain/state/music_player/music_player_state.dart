part of 'music_player_cubit.dart';

class MusicPlayerState {
  // final String? id;
  final Song? song;
  final PlayStatus playStatus;
  final ProcessingState? processingState;
  final PlayerPlaylist? playlist;
  final int? currentSongIndex;
  final bool? isPlaying;

  MusicPlayerState({
    this.playlist,
    this.song,
    this.processingState = ProcessingState.idle,
    this.playStatus = PlayStatus.empty,
    this.currentSongIndex,
    this.isPlaying,
  });

  MusicPlayerState copyWith({
    final Song? song,
    final PlayStatus? playStatus,
    final ProcessingState? processingState,
    final PlayerPlaylist? playlist,
    final int? currentSongIndex,
    final bool? isPlaying,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      playStatus: playStatus ?? this.playStatus,
      processingState: processingState ?? this.processingState,
      playlist: playlist ?? this.playlist,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
