
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
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
      appBar: AppBar(title: Text(playlist.title)),
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
    if (state is PlaylistLoadedState && state.playlist.id == playlist.id) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CoverWidget(photoUrl: state.playlist.photoUrl600, size: 250),
            _TitleWidget(state.playlist.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    : const SizedBox()
              ],
            ),
            MusicList(songList: state.songs),
          ],
        )
      );
    } else if (state is PlaylistLoadingErrorState) {
      return Text(state.error);
    }
    cubit.loadPlaylist(playlist);
    return const Center(child: CircularProgressIndicator());
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
