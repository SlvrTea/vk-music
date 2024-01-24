
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/state/music_player/music_player_bloc.dart';

class SliderButton extends StatefulWidget {
  const SliderButton({super.key});

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> with TickerProviderStateMixin {
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
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
              context.read<MusicPlayerBloc>().add(PlayMusicEvent(index: 0, song: state.song!.copyWith()));
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
