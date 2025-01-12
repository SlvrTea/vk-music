import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/state/music_player/music_player_cubit.dart';
import 'audio_buttons.dart';
import 'audio_details_bottom_sheet.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          isScrollControlled: true, context: context, builder: (_) => const AudioDetailBottomSheet()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(child: MusicBarPlayButton()),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                musicBloc.state.song!.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              Text(
                musicBloc.state.song!.artist,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(
            child: MusicBarNextAudioButton(),
          ),
        ],
      ),
    );
  }
}
