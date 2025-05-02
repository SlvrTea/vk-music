import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

class SliderBar extends StatelessWidget {
  const SliderBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return StreamBuilder(
      stream: player.positionStream,
      builder: (context, position) {
        return StreamBuilder(
          stream: player.bufferedPositionStream,
          builder: (context, buffered) {
            return ProgressBar(
              progress: position.data ?? const Duration(),
              buffered: buffered.data ?? const Duration(),
              thumbRadius: 6,
              total: player.currentAudio!.duration!,
              onSeek: (duration) => player.seek(duration),
            );
          },
        );
      },
    );
  }
}
