import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../music_player.dart';
import '../music_player/music_player_bloc.dart';

part 'music_progress_state.dart';

class MusicProgressCubit extends Cubit<MusicProgressState> {
  final MusicPlayer musicPlayer;
  final MusicPlayerBloc musicPlayerBloc;
  late StreamSubscription positionChangedSubscription;
  late StreamSubscription bufferPositionSubscription;

  MusicProgressCubit({required this.musicPlayer, required this.musicPlayerBloc})
      : super(MusicProgressState()) {
    positionChangedSubscription = musicPlayer.getCurrentPos().listen((event) {
      changeValue(Duration(seconds: event.inSeconds));
    });
    bufferPositionSubscription = musicPlayer.getCurrentBufferPos().listen((event) {
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
