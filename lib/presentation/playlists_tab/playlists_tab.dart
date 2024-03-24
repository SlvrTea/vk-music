
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/presentation/cover.dart';

class PlaylistsTab extends StatelessWidget with PlaylistCoverGetterMixin {
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistsCubit>();
    final state = cubit.state;
    if (state is! PlaylistsLoadedState) {
      cubit.getPlaylists();
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 120/155,
          children: getCovers(state.playlists),
        ),
      ),
    );
  }
}
