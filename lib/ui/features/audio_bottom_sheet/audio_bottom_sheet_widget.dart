import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/widgets/common/media_cover.dart';

import '../../widgets/common/context_menu_item.dart';
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
            child: DoubleValueListenableBuilder(
              firstValue: wm.audios,
              secondValue: wm.cachedAudios,
              builder: (context, audios, cached) {
                if (audios.data == null || cached.data == null) return const Center(child: CircularProgressIndicator());
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
                    if (!audios.data!.any((e) => e.id == audio.id))
                      ContextMenuItem(
                        leading: const Icon(Icons.add_rounded),
                        title: const Text('Добавить в мою музыку'),
                        onTap: wm.onAddAudioTap,
                      ),
                    ContextMenuItem(
                      leading: const Icon(Icons.playlist_add_rounded),
                      title: const Text('Добавить в плейлист'),
                      onTap: wm.onAddToPlaylistTap,
                    ),
                    ContextMenuItem(
                      title: const Text('Слушать далее'),
                      leading: const Icon(Icons.playlist_play_rounded),
                      onTap: wm.onPlayNextTap,
                    ),
                    if (audio.mainArtists != null)
                      ContextMenuItem(
                        title: const Text('Перейти к исполнителю'),
                        leading: const Icon(Icons.person),
                        onTap: wm.onGoToArtistTap,
                      )
                    else
                      ContextMenuItem(
                        title: const Text('Найти исполнителя'),
                        leading: const Icon(Icons.search_rounded),
                        onTap: wm.onFindArtistTap,
                      ),
                    if (audio.album != null)
                      ContextMenuItem(
                        title: const Text('Перейти к альбому'),
                        leading: const Icon(Icons.album_rounded),
                        onTap: wm.onGoToAlbumTap,
                      ),
                    if (!cached.data!.any((e) => e.id == audio.id))
                      ContextMenuItem(
                        title: const Text('Кешировать'),
                        leading: const Icon(Icons.download_rounded),
                        onTap: wm.onCacheTap,
                      )
                    else
                      ContextMenuItem(
                        title: const Text('Удалить из кеша'),
                        leading: const Icon(Icons.delete_forever),
                        onTap: wm.onDeleteCachedTap,
                      ),
                    if (audios.data!.any((e) => e.id == audio.id))
                      ContextMenuItem(
                        leading: const Icon(Icons.delete_outline_rounded),
                        title: const Text('Удалить из моей музыки'),
                        iconColor: Colors.red,
                        onTap: wm.onDeleteAudioTap,
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
