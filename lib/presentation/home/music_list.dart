
import 'package:flutter/material.dart';
import 'package:vk_music/domain/state/music_player/music_player_bloc.dart';
import 'package:vk_music/presentation/home/song_tile.dart';

import '../../data/vk_api/models/song.dart';

class MusicList extends StatelessWidget {
  final List<Song> songList;
  const MusicList({super.key, required this.songList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songList.length,
        itemBuilder: (context, index) {
          return SongTile(song: songList[index], playerMode: PlayerMode.online, index: index);
        }
    );
  }
}
