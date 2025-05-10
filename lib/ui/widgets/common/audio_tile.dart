import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import 'media_cover.dart';

class AudioTile extends StatelessWidget {
  final PlayerAudio audio;
  final bool withMenu;
  final int? playlistId;
  final List<PlayerAudio> playlist;

  const AudioTile({
    super.key,
    required this.audio,
    required this.playlist,
    this.withMenu = false,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    final duration = audio.duration!.inSeconds;
    final formatDuration = '${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}';
    final player = context.global.audioPlayer;
    return ListTile(
      trailing: withMenu
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatDuration, style: context.global.theme.b1),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: context.global.theme.colors.secondaryBackground,
                      builder: (_) => AudioBottomSheetWidget(
                        audio: audio,
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                  color: context.global.theme.colors.mainTextColor,
                )
              ],
            )
          : Text(formatDuration),
      leading: CoverWidget(
        photoUrl: audio.album?.thumb?.photo270,
        child: ListenableBuilder(
          listenable: player,
          builder: (context, _) {
            final isPlaying = player.playing;
            final currentAudio = player.currentAudio;
            if (currentAudio == null || isPlaying == null) return const SizedBox.shrink();
            if (currentAudio.id == audio.id) {
              if (isPlaying) {
                return const Icon(Icons.pause_rounded, size: 48);
              }
              return const Icon(Icons.play_arrow_rounded, size: 48);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      titleTextStyle: context.global.theme.b3,
      title: Text(audio.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        audio.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.global.theme.b1,
      ),
      onTap: () => player.playFrom(playlist: playlist, initialIndex: playlist.indexOf(audio)),
    );
  }
}
