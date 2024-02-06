
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/navbar/audio_buttons.dart';
import 'package:vk_music/presentation/navbar/slider_bar.dart';

import '../../domain/state/music_player/music_player_cubit.dart';

class AudioDetailBottomSheet extends StatefulWidget {
  const AudioDetailBottomSheet({super.key});

  @override
  State<AudioDetailBottomSheet> createState() => _AudioDetailBottomSheetState();
}

class _AudioDetailBottomSheetState extends State<AudioDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CoverWidget(
              photoUrl: musicBloc.state.song?.photoUrl135,
              size: 250,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Text(musicBloc.state.song!.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text(musicBloc.state.song!.artist, style: const TextStyle(fontSize: 16)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MusicBarPreviousAudioButton(),
              MusicBarPlayButton(),
              MusicBarNextAudioButton()
            ],
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SliderBar(),
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              ShuffleButton(),
              Spacer(),
              LoopModeButton()
            ],
          )
        ],
      ),
    );
  }
}
