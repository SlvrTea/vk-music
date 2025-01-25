import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import 'audio_buttons.dart';
import 'audio_details_bottom_sheet.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          isScrollControlled: true, context: context, builder: (_) => const AudioDetailBottomSheet()),
      child: ValueListenableBuilder(
        valueListenable: player.currentAudioNotifier,
        builder: (context, audio, child) => Row(
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
                  audio!.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  audio.artist,
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
      ),
    );
  }
}
