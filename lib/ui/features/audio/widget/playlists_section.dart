import 'package:flutter/material.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

import '../../../widgets/common/media_cover.dart';

class HomePlaylistsSection extends StatelessWidget
    with PlaylistCoverGetterMixin {
  const HomePlaylistsSection(this.playlists, {super.key});

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    final covers = getCovers(playlists);

    return SizedBox(
      height: 149,
      child: ListView.builder(
        itemCount: playlists.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return covers[i];
        },
      ),
    );
  }
}
