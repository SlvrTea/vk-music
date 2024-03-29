
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/artist_tab/artist_tab.dart';
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
      height: 256,
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
          state.songs.contains(song)
            ? const SizedBox()
            : _ContextMenuItem(
                leading: const Icon(Icons.add_rounded),
                title: const Text('Добавить в мою музыку'),
                onTap: () {
                  cubit.addAudio(song);
                  navigatorKey.currentState!.pop();
                  const snackBar = SnackBar(
                    content: Text('Аудиозапись добавлена')
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
            ),
          _ContextMenuItem(
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
          song.mainArtistId != null
            ? _ContextMenuItem(
                title: const Text('Перейти к музыканту'),
                leading: const Icon(Icons.person),
                onTap: () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!
                      .push(MaterialPageRoute(builder: (_) => ArtistTab(song.mainArtistId!)));
                }
            )
            : _ContextMenuItem(
                title: const Text('Найти музыканта'),
                leading: const Icon(Icons.search_rounded),
                onTap: () {
                  navigatorKey.currentState!.pop();
                  context.read<NavBarCubit>().changeTab(1);
                  context.read<SearchCubit>().search(song.artist, count: 20);
                }
            ),
          state.songs.contains(song)
            ? _ContextMenuItem(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Удалить из моей музыки'),
                iconColor: Colors.red,
                onTap: () {
                  final snackBar = SnackBar(
                    content: const Text('Аудиозапись удалена'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    width: 300,
                    elevation: 5,
                    showCloseIcon: true,
                  );
                  cubit.audioDelete(song);
                  navigatorKey.currentState!.pop();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              )
              : const SizedBox()
        ],
      ),
    );
  }
}


class _ContextMenuItem extends StatelessWidget {
  const _ContextMenuItem({super.key, required this.title, required this.leading, required this.onTap, this.iconColor});

  final Widget title;
  final Widget leading;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: iconColor ?? Theme.of(context).colorScheme.primary,
      leading: leading,
      title: title,
      onTap: onTap,
    );
  }
}
