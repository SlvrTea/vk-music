import 'package:flutter/material.dart';
import 'package:text_marquee/text_marquee.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../../audio_detail_bottom_sheet/audio_detail_bottom_sheet.dart';
import 'audio_buttons.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          isScrollControlled: true, context: context, builder: (_) => const AudioDetailBottomSheet()),
      child: ListenableBuilder(
        listenable: player,
        builder: (context, _) {
          final audio = player.currentAudio;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(child: MusicBarPlayButton()),
              ),
              Expanded(
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Center(
                    child: TextMarquee(
                      audio!.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  subtitle: Center(
                    child: TextMarquee(
                      audio.artist,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(child: MusicBarNextAudioButton()),
              ),
            ],
          );
        },
      ),
    );
  }
}
