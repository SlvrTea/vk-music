
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/song.dart';
import '../../domain/state/music_player/music_player_cubit.dart';

class PlayIcon extends StatelessWidget {
  const PlayIcon(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MusicPlayerCubit>();
    return bloc.musicPlayer.player.playing ? const Icon(Icons.pause_rounded, size: 32) : const Icon(Icons.play_arrow_rounded, size: 32);
  }
}
