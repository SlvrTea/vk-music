
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vk_music/data/vk_api/models/song.dart';

import '../../domain/state/music_player/music_player_bloc.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final PlayerMode playerMode;
  final int index;

  const SongTile({super.key, required this.song, required this.playerMode, required this.index});

  Widget getIcon(MusicPlayerBloc bloc) {
    Icon? p;
    if (bloc.state.song != null) {
      p = bloc.state.song == song ? bloc.musicPlayer.player.playing ? const Icon(Icons.pause_rounded, size: 32) : const Icon(Icons.play_arrow_rounded, size: 32) : null;
    }
    final icon = song.photoUrl135 != null
        ? CachedNetworkImage(imageUrl: song.photoUrl135!, width: 55, height: 55)
        : SizedBox(
          height: 55,
          width: 55,
          child: Stack(
            children: [
              Container(color: Colors.grey.withOpacity(0.3)),
              Center(
                child: SvgPicture.asset(
                  'assets/note.svg',
                  width: 35,
                  height: 35,
                ),
              ),
              Center(child: p)
            ]
          )
        );
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerBloc>();
    int duration = int.parse(song.duration);
    return ListTile(
      trailing: Text('${duration ~/ 60}:${duration % 60 == 0 ? '00' : duration % 60}'),
      leading: getIcon(musicBloc),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(song.title),
      subtitle: Text(song.artist),
      onTap: () => musicBloc.add(PlayMusicEvent(song: song, index: index))
    );
  }
}
