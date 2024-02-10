
import 'package:flutter/material.dart';
import 'package:vk_music/domain/utils/getPlaylistSource.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/models/song.dart';

class MusicList extends StatelessWidget {
  final List<Song> songList;
  final bool withMenu;
  const MusicList({super.key, required this.songList, this.withMenu = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songList.map((e) => SongTile(
        song: e,
        withMenu: true,
        playlist: getPlaylistSource(songList),
      )).toList(),
    );
  }
}
