
import 'package:flutter/material.dart';
import 'package:vk_music/domain/state/artist/artist_cubit.dart';
import 'package:vk_music/presentation/cover.dart';

class AllPlaylists extends StatelessWidget with PlaylistCoverGetterMixin {
  const AllPlaylists(this.cubit, {super.key});

  final ArtistCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<ArtistState>(
        valueListenable: ValueNotifier<ArtistState>(cubit.state),
        builder: (_, value, __) {
          if (value.playlists == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 120/155,
            children: getCovers(value.playlists!),
          );
        }
      ),
    );
  }
}
