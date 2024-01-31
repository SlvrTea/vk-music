
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';

import '../../domain/const.dart';

class MusicBarPlayButton extends StatefulWidget {
  const MusicBarPlayButton({super.key});

  @override
  State<MusicBarPlayButton> createState() => _MusicBarPlayButtonState();
}

class _MusicBarPlayButtonState extends State<MusicBarPlayButton> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(curve: Curves.easeInOutCubic, parent: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerCubit, MusicPlayerState>(
      listener: (context, state) {
        if (state.playStatus == PlayStatus.trackPlaying) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.song != null && state.processingState != ProcessingState.idle) {
              context.read<MusicPlayerCubit>().playMusic(song: state.song!);
            }
          },
          child: AnimatedIcon(
            progress: _animation,
            icon: AnimatedIcons.play_pause,
            size: 32,
          ),
        );
      },
    );
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
      icon: Icon(Icons.fast_forward_rounded, size: size ?? 32, color: Colors.white)
    );
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
        icon: Icon(Icons.fast_rewind_rounded, size: size ?? 32, color: Colors.white)
    );
  }
}