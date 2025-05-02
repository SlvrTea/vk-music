import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/audio/widget/playlists_section.dart';
import 'package:vk_music/ui/widgets/common/app_drawer.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';
import 'package:vk_music/ui/widgets/common/custom_app_bar.dart';

import 'audio_screen_wm.dart';

@RoutePage()
class AudioScreen extends ElementaryWidget<IAudioScreenWidgetModel> {
  const AudioScreen({super.key}) : super(defaultAudioScreenWidgetModelFactory);

  @override
  Widget build(IAudioScreenWidgetModel wm) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          wm.loadAudios();
          wm.loadPlaylists();
        },
        displacement: kToolbarHeight,
        edgeOffset: kToolbarHeight,
        child: DoubleValueListenableBuilder(
          firstValue: wm.playlists,
          secondValue: wm.audios,
          builder: (context, playlists, audios) {
            if (playlists.data == null || audios.data == null) return const Center(child: CircularProgressIndicator());
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),
                SliverToBoxAdapter(
                  child: HomePlaylistsSection(playlists.data!),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text('Моя музыка: ${audios.data!.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
                EntityStateNotifierBuilder(
                  listenableEntityState: wm.audios,
                  builder: (context, audios) => SliverReorderableList(
                    itemBuilder: (context, index) {
                      return ReorderableDelayedDragStartListener(
                        key: ValueKey(index),
                        index: index,
                        child: AudioTile(
                          audio: audios[index],
                          playlist: audios,
                          withMenu: true,
                        ),
                      );
                    },
                    itemCount: audios!.length,
                    onReorder: (currentIndex, newIndex) {
                      if (currentIndex < newIndex) {
                        newIndex -= 1;
                      }
                      if (newIndex == 0) {
                        final oldSong = wm.audios.value.data![0];
                        wm.onReorder(audioId: wm.audios.value.data![currentIndex].id, before: oldSong.id);
                        wm.player.move(currentIndex, newIndex);
                        wm.moveAudio(currentIndex, newIndex);
                      } else if (newIndex < currentIndex) {
                        final oldSong = wm.audios.value.data![newIndex - 1];
                        wm.onReorder(audioId: wm.audios.value.data![currentIndex].id, after: oldSong.id);
                        wm.player.move(currentIndex, newIndex);
                        wm.moveAudio(currentIndex, newIndex);
                      } else {
                        final oldSong = wm.audios.value.data![newIndex];
                        wm.onReorder(audioId: wm.audios.value.data![currentIndex].id, after: oldSong.id);
                        wm.player.move(currentIndex, newIndex);
                        wm.moveAudio(currentIndex, newIndex);
                      }
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: wm.mediaQuery.padding.bottom),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
