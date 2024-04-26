
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain/const.dart';
import '../../core/domain/models/player_playlist.dart';
import '../../core/domain/models/song.dart';
import '../../core/domain/state/music_player/music_player_cubit.dart';
import '../../core/presentation/audio_context_menu/audio_context_menu.dart';
import '../../core/presentation/cover.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final bool withMenu;
  final int? playlistId;
  final PlayerPlaylist playlist;

  const SongTile({
    super.key,
    required this.song,
    required this.playlist,
    this.withMenu = false,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    final duration = int.parse(song.duration);
    return ListTile(
      trailing: withMenu
          ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}'),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => MyAudiosMenu(song)
                  );
                },
                icon: const Icon(Icons.more_vert_rounded)
              )
            ]
          )
          : Text('${duration ~/ 60}:${duration % 60 == 0 ? '00' : duration % 60}'),
      leading: CoverWidget(
          photoUrl: song.photoUrl270,
          child: musicBloc.state.song == song
              ? musicBloc.state.playStatus != PlayStatus.trackInPause
              ? const Icon(Icons.pause_rounded, size: 40)
              : const Icon(Icons.play_arrow_rounded, size: 40)
              : null
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => musicBloc.play(playlist: playlist, song: song)
    );
  }
}