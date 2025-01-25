import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_playlist.dart';
import 'package:vk_music/ui/features/album/widget/audio_edit_tile.dart';

import '../../../../data/models/playlist/playlist.dart';
import '../../../widgets/common/media_cover.dart';
import 'edit_playlist_wm.dart';

@RoutePage()
class EditPlaylistScreen extends ElementaryWidget<IEditPlaylistWidgetModel> {
  const EditPlaylistScreen({
    super.key,
    required this.playlist,
  }) : super(defaultEditPlaylistWidgetModelFactory);

  final Playlist playlist;

  @override
  Widget build(IEditPlaylistWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Плейлист'),
        leading: IconButton(
          onPressed: wm.navigateBack,
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          IconButton(
            onPressed: wm.saveChanges,
            icon: const Icon(Icons.check_rounded),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: CoverWidget(photoUrl: playlist.photo!.photo300!, size: 80),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Название'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: wm.titleController,
                            decoration: const InputDecoration(isDense: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 4),
                child: Text('Описание'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: TextField(
                  controller: wm.descriptionController,
                  maxLines: 4,
                ),
              ),
              ListTile(
                title: const Text('Добавить музыку'),
                leading: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 40,
                  ),
                ),
                onTap: wm.onAddAudioTap,
              ),
            ]),
          ),
          EntityStateNotifierBuilder(
            listenableEntityState: wm.audios,
            loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
            builder: (context, audios) {
              if (audios == null) return const SliverToBoxAdapter(child: SizedBox.shrink());
              final p = PlayerPlaylist(children: audios);
              return SliverReorderableList(
                itemBuilder: (context, index) {
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    child: AudioEditTile(
                      audio: audios[index],
                      onIconTap: () => wm.onIconsTap(audios[index]),
                      isAdded: wm.isAdded(audios[index]),
                    ),
                  );
                },
                itemCount: audios.length,
                onReorder: (currentIndex, newIndex) {
                  wm.onReorder(audios[currentIndex], newIndex);
                },
              );
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: wm.mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
