import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/widgets/audio_bottom_sheet_item.dart';
import 'package:vk_music/ui/widgets/common/media_cover.dart';

import 'audio_bottom_sheet_wm.dart';

class AudioBottomSheetWidget extends ElementaryWidget<IAudioBottomSheetWidgetModel> {
  const AudioBottomSheetWidget({
    super.key,
    required this.audio,
  }) : super(defaultAudioBottomSheetWidgetModelFactory);

  final PlayerAudio audio;

  @override
  Widget build(IAudioBottomSheetWidgetModel wm) {
    return Wrap(
      children: [
        SizedBox(
          width: double.infinity,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: EntityStateNotifierBuilder(
              listenableEntityState: wm.audios,
              builder: (context, audios) {
                if (audios == null) return const Center(child: CircularProgressIndicator());
                return Column(
                  children: [
                    const SizedBox(height: 4),
                    ListTile(
                      leading: CoverWidget(
                        photoUrl: audio.album?.thumb?.photo135,
                      ),
                      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                      title: Text(
                        audio.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        audio.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Divider(),
                    if (!audios.contains(audio))
                      AudioBottomSheetItem(
                        leading: const Icon(Icons.add_rounded),
                        title: const Text('Добавить в мою музыку'),
                        onTap: () => wm.onAddAudioTap(audio),
                      ),
                    AudioBottomSheetItem(
                      leading: const Icon(Icons.playlist_add_rounded),
                      title: const Text('Добавить в плейлист'),
                      onTap: wm.onAddToPlaylistTap,
                    ),
                    AudioBottomSheetItem(
                      title: const Text('Слушать далее'),
                      leading: const Icon(Icons.playlist_play_rounded),
                      onTap: () => wm.onPlayNextTap(audio),
                    ),
                    if (audio.mainArtists != null)
                      AudioBottomSheetItem(
                        title: const Text('Перейти к исполнителю'),
                        leading: const Icon(Icons.person),
                        onTap: () => wm.onGoToArtistTap(audio.mainArtists!.first.id!),
                      )
                    else
                      AudioBottomSheetItem(
                        title: const Text('Найти исполнителя'),
                        leading: const Icon(Icons.search_rounded),
                        onTap: () => wm.onFindArtistTap(audio),
                      ),
                    if (audio.album != null)
                      AudioBottomSheetItem(
                        title: const Text('Перейти к альбому'),
                        leading: const Icon(Icons.album_rounded),
                        onTap: () => wm.onGoToAlbumTap(audio),
                      ),
                    if (audios.contains(audio))
                      AudioBottomSheetItem(
                        leading: const Icon(Icons.delete_outline_rounded),
                        title: const Text('Удалить из моей музыки'),
                        iconColor: Colors.red,
                        onTap: () => wm.onDeleteAudioTap(audio),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
