import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import '../../../data/models/song/song.dart';
import '../../../domain/enum/play_status.dart';
import '../../../domain/model/player_playlist.dart';
import '../../../domain/state/music_player/music_player_cubit.dart';
import 'media_cover.dart';

class HorizontalMusicList extends StatelessWidget {
  const HorizontalMusicList(this.songs, {super.key});

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    final playlist = PlayerPlaylist.formSongList(songs);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .21,
      child: GridView.count(
        childAspectRatio: 55 / (MediaQuery.of(context).size.width * .75),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 3,
        scrollDirection: Axis.horizontal,
        children: songs.map((e) => _CustomSongTile(song: e, playlist: playlist)).toList(),
      ),
    );
  }
}

class _CustomSongTile extends StatelessWidget {
  const _CustomSongTile({super.key, required this.song, required this.playlist});

  final Song song;
  final PlayerPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    final duration = song.duration;
    final width = MediaQuery.of(context).size.width * .75;
    return InkWell(
      onTap: () => musicBloc.play(playlist: playlist, song: song),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            CoverWidget(
                photoUrl: song.album?.thumb.photo270,
                child: musicBloc.state.song == song
                    ? musicBloc.state.playStatus != PlayStatus.trackInPause
                        ? const Icon(Icons.pause_rounded, size: 40)
                        : const Icon(Icons.play_arrow_rounded, size: 40)
                    : null),
            const SizedBox(width: 8),
            SizedBox(
              width: width * .5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Spacer(),
            Text('${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}'),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(context: context, builder: (_) => AudioBottomSheetWidget(audio: song));
                },
                icon: const Icon(Icons.more_vert_rounded)),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
