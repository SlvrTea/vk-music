
import 'package:flutter/material.dart';
import 'package:vk_music/domain/models/playlist.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/cover.dart';

class AllPlaylists extends StatelessWidget with PlaylistCoverGetterMixin {
  const AllPlaylists(this.cubit, {super.key});

  final SearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = (cubit.state as SearchFinishedState);
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Playlist>?>(
        valueListenable: ValueNotifier<List<Playlist>?>(state.playlistsResult),
        builder: (_, value, __) {
          if (value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 120/155,
            children: getCovers(value),
          );
        }
      ),
    );
  }
}
