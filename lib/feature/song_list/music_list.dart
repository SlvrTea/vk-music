
import 'package:flutter/material.dart';
import 'package:vk_music/feature/song_list/song_tile.dart';

import '../../core/domain/models/player_playlist.dart';
import '../../core/domain/models/song.dart';

class MusicList extends StatelessWidget {
  final List<Song> songs;
  final bool withMenu;
  const MusicList({super.key, required this.songs, this.withMenu = false});

  @override
  Widget build(BuildContext context) {
    final playlist = PlayerPlaylist.formSongList(songs);
    return Column(
      children: songs.map((e) => SongTile(
        song: e,
        withMenu: withMenu,
        playlist: playlist,
      )).toList(),
    );
  }
}
