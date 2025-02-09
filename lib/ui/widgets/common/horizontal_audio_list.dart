import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import '../../../domain/model/player_playlist.dart';
import 'media_cover.dart';

class HorizontalMusicList extends StatelessWidget {
  const HorizontalMusicList(this.audios, {super.key});

  final List<PlayerAudio> audios;

  @override
  Widget build(BuildContext context) {
    final playlist = PlayerPlaylist(children: audios);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .21,
      child: GridView.count(
        childAspectRatio: 55 / (MediaQuery.of(context).size.width * .75),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 3,
        scrollDirection: Axis.horizontal,
        children: audios.map((e) => _CustomSongTile(audio: e, playlist: playlist)).toList(),
      ),
    );
  }
}

class _CustomSongTile extends StatelessWidget {
  const _CustomSongTile({super.key, required this.audio, required this.playlist});

  final PlayerAudio audio;
  final PlayerPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    final duration = audio.duration!.inSeconds;
    final width = MediaQuery.of(context).size.width * .75;
    return InkWell(
      onTap: () => player.playFrom(playlist: playlist, initialIndex: playlist.children.indexOf(audio)),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            CoverWidget(
              photoUrl: audio.album?.thumb?.photo270,
              child: DoubleValueListenableBuilder(
                firstValue: player.currentAudioNotifier,
                secondValue: player.isPlaying,
                builder: (context, currentAudio, isPlaying) {
                  if (currentAudio == null || isPlaying == null) return const SizedBox.shrink();
                  if (currentAudio == audio) {
                    if (isPlaying) {
                      return const Icon(Icons.pause_rounded, size: 40);
                    }
                    return const Icon(Icons.play_arrow_rounded, size: 40);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: width * .5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(audio.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Spacer(),
            Text('${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}'),
            IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (_) => AudioBottomSheetWidget(audio: audio));
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
