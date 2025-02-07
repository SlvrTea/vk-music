import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/ui/widgets/common/playlist_widget.dart';

@RoutePage()
class AllPlaylistsScreen extends StatelessWidget {
  const AllPlaylistsScreen({super.key, required this.playlists});

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 120 / 155,
        children: [
          ...playlists.map((e) => PlaylistWidget(playlist: e)),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }
}
