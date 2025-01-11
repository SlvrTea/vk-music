import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import '../../domain/state/music_player/music_player_cubit.dart';
import 'audio_buttons.dart';
import 'audio_details_bottom_sheet.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();

    return Container(
      color: Colors.transparent, // Match navbar transparency
      child: InkWell(
        onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => const AudioDetailBottomSheet()),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(child: MusicBarPlayButton()),
              ),
              const SizedBox(
                child: MusicBarNextAudioButton(),
              ),
              Expanded(
                child: ListTile(
                    subtitle: Text(
                      musicBloc.state.song!.artist,
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                    title: Text(
                      musicBloc.state.song!.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
