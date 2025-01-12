import 'package:flutter/material.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

import '../../../widgets/common/media_cover.dart';

class HomePlaylistsSection extends StatelessWidget with PlaylistCoverGetterMixin {
  const HomePlaylistsSection(this.playlists, {super.key});

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 149,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getCovers(playlists),
        ),
      ),
    );
  }
}
