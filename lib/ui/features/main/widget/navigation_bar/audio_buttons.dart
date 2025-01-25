import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

class MusicBarPlayButton extends StatelessWidget {
  const MusicBarPlayButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return ValueListenableBuilder(
      valueListenable: player.isPlaying,
      builder: (context, playing, child) => GestureDetector(
        onTap: playing! ? player.pause : player.play,
        child: playing ? Icon(Icons.pause_rounded, size: size ?? 32) : Icon(Icons.play_arrow_rounded, size: size ?? 32),
      ),
    );
  }
}

class MusicBarNextAudioButton extends StatelessWidget {
  const MusicBarNextAudioButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return IconButton(
      onPressed: player.seekToNext,
      icon: Icon(Icons.fast_forward_rounded, size: size ?? 32, color: context.global.theme.colors.mainTextColor),
    );
  }
}

class MusicBarPreviousAudioButton extends StatelessWidget {
  const MusicBarPreviousAudioButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return IconButton(
      onPressed: player.seekToPrevious,
      icon: Icon(
        Icons.fast_rewind_rounded,
        size: size ?? 32,
        color: context.global.theme.colors.mainTextColor,
      ),
    );
  }
}

class ShuffleButton extends StatefulWidget {
  const ShuffleButton({super.key});

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return IconButton(
        onPressed: () {
          player.switchShuffleMode();
          setState(() {});
        },
        icon: Stack(alignment: Alignment.center, children: [
          player.shuffleModeEnabled
              ? Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.withOpacity(0.3)),
                  width: 46,
                  height: 32,
                )
              : const SizedBox(width: 46),
          Icon(
            Icons.shuffle_rounded,
            size: 32,
            color: player.shuffleModeEnabled ? context.global.theme.colors.mainTextColor : Colors.grey,
          )
        ]));
  }
}

class LoopModeButton extends StatefulWidget {
  const LoopModeButton({super.key});

  @override
  State<LoopModeButton> createState() => _LoopModeButtonState();
}

class _LoopModeButtonState extends State<LoopModeButton> {
  late LoopMode loopMode;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    loopMode = player.loopMode;
    if (loopMode == LoopMode.off) {
      isSelected = false;
    } else {
      isSelected = true;
    }
    return IconButton(
        onPressed: () {
          switch (loopMode) {
            case LoopMode.off:
              loopMode = LoopMode.all;
            case LoopMode.all:
              loopMode = LoopMode.one;
            case LoopMode.one:
              loopMode = LoopMode.off;
          }
          setState(() {
            if (loopMode == LoopMode.off) {
              isSelected = false;
            } else {
              isSelected = true;
            }
          });
          player.setLoopMode(loopMode);
        },
        icon: Stack(alignment: Alignment.center, children: [
          isSelected
              ? Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.withOpacity(0.3)),
                  width: 46,
                  height: 32,
                )
              : const SizedBox(width: 46),
          Icon(
            loopMode == LoopMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            size: 32,
            color: isSelected ? context.global.theme.colors.mainTextColor : Colors.grey,
          )
        ]));
  }
}
