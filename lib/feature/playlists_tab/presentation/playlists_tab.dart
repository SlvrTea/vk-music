
import 'package:flutter/material.dart';
import 'package:vk_music/core/presentation/scaffold_with_navbar.dart';
import 'package:vk_music/feature/playlists_tab/presentation/widget/body.dart';

class PlaylistsTab extends StatelessWidget {
  const PlaylistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      appBar: AppBar(title: const Text('VKMusic')),
      child: const PlaylistsTabBody()
    );
  }
}
