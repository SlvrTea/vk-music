import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models/music_player.dart';

part 'music_progress_state.dart';

class MusicProgressCubit extends Cubit<MusicProgressState> {
  final MusicPlayer musicPlayer;
  late StreamSubscription positionChangedSubscription;
  late StreamSubscription bufferPositionSubscription;

  MusicProgressCubit({required this.musicPlayer})
      : super(MusicProgressState()) {
    positionChangedSubscription = musicPlayer.player.positionStream.listen((event) {
      changeValue(Duration(seconds: event.inSeconds));
    });
    bufferPositionSubscription = musicPlayer.player.bufferedPositionStream.listen((event) {
      changeBufferValue(event);
    });
  }
  void changeValue(Duration value) => emit(state.copyWith(currentDuration: value));

  void changeBufferValue(Duration value) => emit(state.copyWith(bufferDuration: value));

  void seekValue(Duration value) {
    musicPlayer.seek(value);
    emit(state.copyWith(currentDuration: value));
  }
}
