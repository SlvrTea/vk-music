
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/playlists_tab/playlist_edit_screen.dart';

import '../../domain/models/playlist.dart';
import '../../domain/state/playlist/playlist_cubit.dart';
import '../song_list/music_list.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Плейлист')),
      body: _BodyWidget(playlist),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistCubit>();
    final state = cubit.state;
    if (state is PlaylistLoadedState) {
      if (state.playlist.id != playlist.id) cubit.loadPlaylist(playlist);
    } else if (state is! PlaylistLoadingErrorState) {
      cubit.loadPlaylist(playlist);
    }
    return (state is PlaylistLoadedState && state.playlist.id == playlist.id)
        ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CoverWidget(photoUrl: state.playlist.photoUrl600, size: 250),
              _TitleWidget(state.playlist.title),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MusicPlayerCubit>().playMusic(
                        song: state.songs.first,
                        playlist: PlayerPlaylist.formSongList(state.songs)
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Слушать')
                  ),
                  const SizedBox(width: 8),
                  playlist.isOwner
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => navigatorKey.currentState!
                          .push(MaterialPageRoute(builder: (_) => const PlaylistEdit())),
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Изменить')
                      ),

                    )
                    : const SizedBox(),
                  !playlist.isFollowing
                      ? playlist.isOwner ? const SizedBox()
                      : ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Добавить'),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 20, 20, 20)
                            ),
                            foregroundColor: const MaterialStatePropertyAll(Colors.white),
                          ),
                       )
                      : SizedBox(
                        width: 90,
                        child: IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.check_rounded),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 20, 20, 20)
                            ),
                            foregroundColor: const MaterialStatePropertyAll(Colors.white),
                          ),
                        ),
                      )
                  ],
              ),
              playlist.description != null
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(playlist.description!,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)
                      ),
                  )
                  : const SizedBox(),
              const Divider(),
              MusicList(songs: state.songs, withMenu: true),
            ],
          )
        )
      : const Center(child: CircularProgressIndicator());
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
