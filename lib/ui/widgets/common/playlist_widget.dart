import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/router/app_router.dart';

import '../../../data/models/playlist/playlist.dart';
import 'media_cover.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({super.key, required this.playlist, this.size = 115});

  final Playlist playlist;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 16,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.router.push(AlbumRoute(playlist: playlist)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CoverWidget(
              photoUrl: playlist.thumbs?.first.photo600 ?? playlist.photo?.photo600,
              borderRadius: BorderRadius.circular(16),
              size: size,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                playlist.title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
