
import 'package:flutter/material.dart';
import 'package:vk_music/domain/state/music_player/music_player_bloc.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../data/vk_api/models/song.dart';

class MusicList extends StatelessWidget {
  final List<Song> songList;
  const MusicList({super.key, required this.songList});

  List<Widget> songs() {
    final result = <Widget>[];
    for (int i = 0; i < songList.length; i++) {
      result.add(SongTile(song: songList[i], playerMode: PlayerMode.online, index: i));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs()
    );
  }
}
