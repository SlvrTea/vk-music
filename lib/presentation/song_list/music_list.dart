
import 'package:flutter/material.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/models/song.dart';

class MusicList extends StatelessWidget {
  final List<Song> songs;
  final bool withMenu;
  const MusicList({super.key, required this.songs, this.withMenu = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.map((e) => SongTile(
        song: e,
        withMenu: withMenu,
        playlist: PlayerPlaylist.formSongList(songs),
      )).toList(),
    );
  }
}
