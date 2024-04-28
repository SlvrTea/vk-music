
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/core/presentation/cover.dart';
import 'package:vk_music/feature/playlist_tab/presentation/playlist_tab.dart';

import '../../../../core/domain/const.dart';
import '../../../../core/domain/models/playlist.dart';

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
        onTap: () => context.go('/playlist', extra: playlist),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CoverWidget(photoUrl: playlist.photoUrl600, borderRadius: BorderRadius.circular(16), size: size),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(playlist.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
