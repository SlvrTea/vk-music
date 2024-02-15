
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/presentation/playlists_tab/select_playlist.dart';

import '../../domain/models/song.dart';
import '../../domain/state/music_loader/music_loader_cubit.dart';
import '../cover.dart';

class MyAudiosMenu extends StatelessWidget {
  const MyAudiosMenu(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MusicLoaderCubit>();
    final state = cubit.state as MusicLoadedState;
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          ListTile(
            leading: CoverWidget(photoUrl: song.photoUrl135,),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.playlist_add_rounded),
            title: const Text('Добавить в плейлист'),
            onTap: () {
              final ownedPlaylists = (context.read<PlaylistsCubit>().state as PlaylistsLoadedState)
                  .playlists.where((element) => element.isOwner).toList();
              if (ownedPlaylists.isNotEmpty) {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (_) => SelectPlaylist(song, ownedPlaylists)));
              }
            },
          ),
          state.songs.contains(song)
              ? ListTile(
                leading: const Icon(Icons.delete_rounded),
                title: const Text('Удалить из моей музыки'),
                onTap: () {
                  cubit.audioDelete(song);
                  navigatorKey.currentState!.pop();
                }
              )
              : ListTile(
                leading: const Icon(Icons.add_rounded),
                title: const Text('Добавить в мою музыку'),
                onTap: () {
                  cubit.addAudio(song);
                  navigatorKey.currentState!.pop();
                }
              )
        ],
      ),
    );
  }
}
