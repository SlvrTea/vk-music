
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/core/presentation/cover.dart';

import '../../../../core/domain/const.dart';
import '../../../../core/domain/models/song.dart';
import '../../../../core/domain/state/music_loader/music_loader_cubit.dart';
import '../../domain/state/playlist_cubit.dart';

class AddMusicScreen extends StatelessWidget {
  AddMusicScreen(this.playlistCubit, {super.key});

  final PlaylistCubit playlistCubit;
  final audioToAdd = <Song>[];

  @override
  Widget build(BuildContext context) {
    final musicLoaderState = context.watch<MusicLoaderCubit>().state;
    final playlistState = (playlistCubit.state as PlaylistLoadedState);
    final playlistSongs = playlistState.songs;
    if (musicLoaderState is MusicLoadedState) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Добавить Музыку'),
          actions: [
            IconButton(
              onPressed: () {
                if (audioToAdd.isNotEmpty) {
                  playlistCubit.savePlaylist(playlist: playlistState.playlist, songsToAdd: audioToAdd);
                }
                context.pop();
              },
              icon: const Icon(Icons.check)
            )
          ],
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: musicLoaderState.songs.length,
          itemBuilder: (context, index) {
            final song = musicLoaderState.songs[index];
            if (!playlistSongs.contains(song)) {
              return _AddTile(song, audioToAdd);
            } else {
              return const SizedBox();
            }
          }
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _AddTile extends StatefulWidget {
  const _AddTile(this.song, this.audioToAdd, {super.key});

  final Song song;
  final List<Song> audioToAdd;

  @override
  State<_AddTile> createState() => _AddTileState();
}

class _AddTileState extends State<_AddTile> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CoverWidget(photoUrl: widget.song.photoUrl135),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(widget.song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(widget.song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: isSelected ? const Icon(Icons.check_box_rounded) : const Icon(Icons.check_box_outline_blank_rounded),
      onTap: () => setState(() {
        if (isSelected) {
          widget.audioToAdd.remove(widget.song);
        } else {
          widget.audioToAdd.add(widget.song);
        }
        isSelected = !isSelected;
      }),
    );
  }
}
