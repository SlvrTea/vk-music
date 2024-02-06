
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/state/playlist/playlist_cubit.dart';
import 'package:vk_music/presentation/cover.dart';

import '../../data/vk_api/models/song.dart';
import '../../domain/music_loader/music_loader_cubit.dart';

final _audiosToAdd = <String>[];

class AddMusicScreen extends StatelessWidget {
  const AddMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final musicLoaderState = context.watch<MusicLoaderCubit>().state;
    final playlistCubit = context.read<PlaylistCubit>();
    final playlistState = (playlistCubit.state as PlaylistLoadedState);
    final playlistSongs = playlistState.songs;
    if (musicLoaderState is MusicLoadedState) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Добавить Музыку'),
          actions: [
            IconButton(
              onPressed: () {
                if (_audiosToAdd.isNotEmpty) {
                  playlistCubit.addAudiosToPlaylist(playlistState.playlist, _audiosToAdd);
                }
                navigatorKey.currentState!.pop();
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
              return _AddTile(song);
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
  const _AddTile(this.song, {super.key});

  final Song song;

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
          _audiosToAdd.remove(widget.song.id);
        } else {
          _audiosToAdd.add(widget.song.id!);
        }
        isSelected = !isSelected;
      }),
    );
  }
}
