
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/data/vk_api/models/song.dart';

import '../../domain/state/music_player/music_player_bloc.dart';
import '../cover.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final PlayerMode playerMode;
  final int index;

  const SongTile({super.key, required this.song, required this.playerMode, required this.index});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerBloc>();
    int duration = int.parse(song.duration);
    return ListTile(
      trailing: Text('${duration ~/ 60}:${duration % 60 == 0 ? '00' : duration % 60}'),
      leading: CoverWidget(
          photoUrl: song.photoUrl135,
          child: musicBloc.state.song == song
              ? musicBloc.musicPlayer.player.playing
              ? const Icon(Icons.pause_rounded, size: 40)
              : const Icon(Icons.play_arrow_rounded, size: 40)
              : null
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => musicBloc.add(PlayMusicEvent(song: song, index: index))
    );
  }
}