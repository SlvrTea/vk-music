
import 'package:flutter/material.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/models/player_playlist.dart';
import '../../domain/models/song.dart';

class LazyLoadMusicList extends StatelessWidget {
  const LazyLoadMusicList({super.key, required this.songs, this.withMenu = true});

  final List<Song> songs;
  final bool withMenu;

  @override
  Widget build(BuildContext context) {
    final playlist = PlayerPlaylist.formSongList(songs);
    return SingleChildScrollView(
      child: Column(
        children: songs.map((e) {
          if ((songs.indexOf(e) == songs.length - 1)
              && (songs.length % 10 == 0) && (songs.length >= 30)) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
            ));
          }
          return SongTile(song: e, playlist: playlist, withMenu: withMenu);
        }).toList(),
      ),
    );
  }
}
