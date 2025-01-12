part of 'music_progress_cubit.dart';

class MusicProgressState {
  final Duration? currentDuration;
  final Duration? bufferDuration;
  MusicProgressState({
    this.currentDuration,
    this.bufferDuration,
  });

  MusicProgressState copyWith({
    Duration? currentDuration,
    Duration? bufferDuration,
  }) {
    return MusicProgressState(
      currentDuration: currentDuration ?? this.currentDuration,
      bufferDuration: bufferDuration ?? this.bufferDuration,
    );
  }
}
