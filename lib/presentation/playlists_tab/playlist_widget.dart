
import 'package:flutter/material.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/models/playlist.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/playlists_tab/playlist_screen.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 150,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (_) => PlaylistScreen(playlist))
          );
        },
        child: Column(
          children: [
            CoverWidget(photoUrl: playlist.photoUrl600, borderRadius: BorderRadius.circular(16), size: 115),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(playlist.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
