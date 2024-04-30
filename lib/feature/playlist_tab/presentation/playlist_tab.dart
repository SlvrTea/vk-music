
import 'package:flutter/material.dart';
import 'package:vk_music/core/domain/models/playlist.dart';
import 'package:vk_music/core/presentation/scaffold_with_navbar.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/playlist_tab.dart';

class PlaylistTab extends StatelessWidget {
  const PlaylistTab(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      appBar: AppBar(title: const Text('Плейлист'),),
      child: PlaylistTabBody(playlist)
    );
  }
}
