
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/core/presentation/cover.dart';

import '../../domain/state/playlists_cubit.dart';

class PlaylistsTabBody extends StatelessWidget with PlaylistCoverGetterMixin {
  const PlaylistsTabBody({super.key});

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
