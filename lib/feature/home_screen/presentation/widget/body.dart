import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/feature/home_screen/presentation/widget/home_playlist_section.dart';

import '../../../../core/domain/models/player_playlist.dart';
import '../../../../core/domain/state/music_loader/music_loader_cubit.dart';
import '../../../playlists_tab/domain/state/playlists_cubit.dart';
import '../../../song_list/song_tile.dart';

class HomeTabBody extends StatelessWidget {
  const HomeTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MusicLoaderCubit>();
    final state = cubit.state;
    if (state is! MusicLoadedState) {
      return const Center(child: CircularProgressIndicator());
    }
    final playlist = PlayerPlaylist.formSongList(state.songs);
    return RefreshIndicator(
      onRefresh: () async {
        cubit.loadMusic();
        context.read<PlaylistsCubit>().getPlaylists();
      },
      displacement: kToolbarHeight,
      edgeOffset: kToolbarHeight,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SliverToBoxAdapter(
            child: HomePlaylistsSection(),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text('Моя музыка: ${state.songs.length}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          )),
          SliverReorderableList(
              itemBuilder: (context, index) {
                return Material(
                  key: ValueKey(index),
                  child: ReorderableDelayedDragStartListener(
                      index: index,
                      child: SongTile(
                          song: state.songs[index],
                          withMenu: true,
                          playlist: playlist)),
                );
              },
              itemCount: state.songs.length,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                if (newIndex == 0) {
                  final oldSongId = state.songs[0].shortId;
                  final item = state.songs.removeAt(oldIndex);
                  state.songs.insert(newIndex, item);
                  cubit.reorder(item, before: oldSongId);
                } else if (newIndex < oldIndex) {
                  final oldSongId = state.songs[newIndex - 1].shortId;
                  final item = state.songs.removeAt(oldIndex);
                  state.songs.insert(newIndex, item);
                  cubit.reorder(item, after: oldSongId);
                } else {
                  final oldSongId = state.songs[newIndex].shortId;
                  final item = state.songs.removeAt(oldIndex);
                  state.songs.insert(newIndex, item);
                  cubit.reorder(item, after: oldSongId);
                }
              }),
          SliverToBoxAdapter(
            child: SizedBox(
              height: kToolbarHeight + (MediaQuery.of(context).padding.bottom),
            ),
          ),
        ],
      ),
    );
  }
}
