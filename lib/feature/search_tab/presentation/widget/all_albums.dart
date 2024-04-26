
import 'package:flutter/material.dart';
import 'package:vk_music/core/presentation/cover.dart';

import '../../../../core/domain/models/playlist.dart';
import '../../domain/state/search_cubit.dart';

class AllAlbums extends StatelessWidget with PlaylistCoverGetterMixin {
  const AllAlbums(this.cubit, {super.key});

  final SearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = cubit.state;
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Playlist>?>(
          valueListenable: ValueNotifier<List<Playlist>?>(state.albums),
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
