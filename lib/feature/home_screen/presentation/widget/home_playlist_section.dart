
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cover.dart';
import '../../../playlists_tab/domain/state/playlists_cubit.dart';

class HomePlaylistsSection extends StatelessWidget with PlaylistCoverGetterMixin {
  const HomePlaylistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistsCubit>();
    final state = cubit.state;
    if (state is! PlaylistsLoadedState) {
      cubit.getPlaylists();
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 149,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getCovers(state.playlists),
        ),
      ),
    );
  }
}