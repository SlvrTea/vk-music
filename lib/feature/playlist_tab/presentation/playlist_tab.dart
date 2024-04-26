
import 'package:flutter/material.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/body.dart';

import '../../../core/domain/models/playlist.dart';

class PlaylistTab extends StatelessWidget {
  const PlaylistTab(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Плейлист')),
      body: PlaylistTabBody(playlist),
    );
  }
}