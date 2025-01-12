import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../domain/enum/play_status.dart';
import '../../../../../domain/state/music_player/music_player_cubit.dart';

class MusicBarPlayButton extends StatelessWidget {
  const MusicBarPlayButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MusicPlayerCubit>().state;
    return GestureDetector(
        onTap: () {
          if (state.song != null && state.processingState != ProcessingState.idle) {
            context.read<MusicPlayerCubit>().play(song: state.song!);
          }
        },
        child: state.playStatus != PlayStatus.trackInPause
            ? Icon(Icons.pause_rounded, size: size ?? 32)
            : Icon(Icons.play_arrow_rounded, size: size ?? 32));
  }
}

class MusicBarNextAudioButton extends StatelessWidget {
  const MusicBarNextAudioButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final musicCubit = context.watch<MusicPlayerCubit>();
    return IconButton(
        onPressed: () {
          musicCubit.seekToNext();
        },
        icon: Icon(Icons.fast_forward_rounded, size: size ?? 32));
  }
}

class MusicBarPreviousAudioButton extends StatelessWidget {
  const MusicBarPreviousAudioButton({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final musicCubit = context.watch<MusicPlayerCubit>();
    return IconButton(
        onPressed: () {
          musicCubit.seekToPrevious();
        },
        icon: Icon(Icons.fast_rewind_rounded, size: size ?? 32));
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
    final musicPlayerCubit = context.watch<MusicPlayerCubit>();
    return IconButton(
        onPressed: () {
          musicPlayerCubit.switchShuffleMode();
          setState(() {});
        },
        icon: Stack(alignment: Alignment.center, children: [
          musicPlayerCubit.getShuffle()
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
            color: musicPlayerCubit.getShuffle() ? Colors.white : Colors.grey,
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
    final musicPlayerCubit = context.read<MusicPlayerCubit>();
    loopMode = musicPlayerCubit.getLoopMode();
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
          musicPlayerCubit.setLoopMode(loopMode);
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
            color: isSelected ? Colors.white : Colors.grey,
          )
        ]));
  }
}
