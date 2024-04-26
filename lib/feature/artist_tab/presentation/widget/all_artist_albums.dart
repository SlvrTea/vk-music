
import 'package:flutter/material.dart';
import 'package:vk_music/core/presentation/cover.dart';

import '../../domain/state/artist_cubit.dart';

class AllArtistAlbums extends StatelessWidget with PlaylistCoverGetterMixin {
  const AllArtistAlbums(this.cubit, {super.key});

  final ArtistCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<ArtistState>(
        valueListenable: ValueNotifier<ArtistState>(cubit.state),
        builder: (_, value, __) {
          if (value.artistAlbums == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 120/155,
            children: getCovers(value.artistAlbums!),
          );
        }
      ),
    );
  }
}
