part of 'music_player_bloc.dart';

class MusicPlayerState {
  // final String? id;
  final Song? song;
  final int? nextSongIndex;
  final PlayStatus playStatus;
  final PlayerMode playerMode;
  final bool onlineSong;
  final int playlistId;
  final ProcessingState? processingState;
  MusicPlayerState({
    this.song,
    this.nextSongIndex,
    this.processingState = ProcessingState.idle,
    this.playStatus = PlayStatus.empty,
    this.playerMode = PlayerMode.online,
    this.onlineSong = true,
    this.playlistId = -1,
  });

  MusicPlayerState copyWith({
    final Song? song,
    final int? nextSongIndex,
    final PlayStatus? playStatus,
    final PlayerMode? playerMode,
    final bool? onlineSong,
    final int? playlistId,
    final ProcessingState? processingState,
  }) {
    return MusicPlayerState(
      song: song ?? this.song,
      nextSongIndex: nextSongIndex ?? this.nextSongIndex,
      playStatus: playStatus ?? this.playStatus,
      playerMode: playerMode ?? this.playerMode,
      onlineSong: onlineSong ?? this.onlineSong,
      playlistId: playlistId ?? this.playlistId,
      processingState: processingState ?? this.processingState,
    );
  }
}