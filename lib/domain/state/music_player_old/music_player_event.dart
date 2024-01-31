// part of 'music_player_bloc.dart';
//
// @immutable
// abstract class MusicPlayerEvent {}
//
// class PlayMusicEvent extends MusicPlayerEvent {
//   final Song song;
//   final int index;
//   final int? offset;
//   final int? playlistId;
//   PlayMusicEvent({
//     required this.song,
//     required this.index,
//     this.offset,
//     this.playlistId,
//   });
// }
//
// class StopMusicWhenCompletedEvent extends MusicPlayerEvent {}
//
// class ResumeMusicEvent extends MusicPlayerEvent {}
//
// class PauseMusicEvent extends MusicPlayerEvent {}
//
// class PlayNextEvent extends MusicPlayerEvent {
//   final int offset;
//   PlayNextEvent({
//     required this.offset,
//   });
// }
//
// class ChangePlayerMode extends MusicPlayerEvent {
//   final PlayerMode playMode;
//   ChangePlayerMode({
//     required this.playMode,
//   });
// }
//
// class ChangePlayerState extends MusicPlayerEvent {
//   final ProcessingState processingState;
//   ChangePlayerState({
//     required this.processingState,
//   });
// }
