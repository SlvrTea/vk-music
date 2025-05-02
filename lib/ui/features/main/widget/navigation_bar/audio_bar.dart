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
        builder: (context, audio, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: SizedBox(child: MusicBarPlayButton()),
            ),
            Expanded(
              child: ListTile(
                title: Center(
                  child: Text(
                    audio!.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    audio.artist,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(child: MusicBarNextAudioButton()),
            ),
          ],
        ),
      ),
    );
  }
}
