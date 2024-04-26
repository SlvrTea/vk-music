
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/state/music_player/music_player_cubit.dart';
import '../../domain/state/music_progress/music_progress_cubit.dart';

class SliderBar extends StatelessWidget {
  const SliderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProgress = context.watch<MusicProgressCubit>();
    final musicBloc = context.read<MusicPlayerCubit>();
    return ProgressBar(
      progress: musicProgress.state.currentDuration ?? const Duration(),
      buffered: musicProgress.state.bufferDuration ?? const Duration(),
      thumbRadius: 6,
      total: Duration(seconds: int.parse(musicBloc.state.song!.duration)),
      onSeek: (duration) => musicProgress.seekValue(duration),
    );
  }
}
