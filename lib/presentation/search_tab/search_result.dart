
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/playlists_tab/playlist_widget.dart';
import 'package:vk_music/presentation/search_tab/all_albums.dart';
import 'package:vk_music/presentation/search_tab/all_songs.dart';
import 'package:vk_music/presentation/song_list/horizontal_music_list.dart';

import '../../domain/const.dart';
import '../../domain/models/playlist.dart';
import 'all_playlists.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final state = (cubit.state as SearchFinishedState);
    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('ВСЕ АУДИОЗАПИСИ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  navigatorKey.currentState!
                      .push(MaterialPageRoute(builder: (_) => AllSongs(cubit)));
                },
                child: const Text('Показать все')
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: _SearchSongsWidget(),
        ),
        if (state.albumResult != null && state.albumResult!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Альбомы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    navigatorKey.currentState!
                        .push(MaterialPageRoute(builder: (_) => AllAlbums(cubit)));
                  },
                  child: const Text('Показать все')
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _SearchAlbumsWidget(state.albumResult!),
          ),
        ],
        if (state.playlistsResult!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text('Плейлисты', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    navigatorKey.currentState!
                        .push(MaterialPageRoute(builder: (_) => AllPlaylists(cubit)));
                  },
                  child: const Text('Показать все')
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _SearchAlbumsWidget(state.playlistsResult!),
          ),
        ]
      ])
    );
  }
}

class _SearchAlbumsWidget extends StatelessWidget {
  const _SearchAlbumsWidget(this.playlists, {super.key});

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: playlists.map((e) => PlaylistWidget(playlist: e)).toList(),
      ),
    );
  }
}

class _SearchSongsWidget extends StatelessWidget {
  const _SearchSongsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = (context.watch<SearchCubit>().state as SearchFinishedState).searchResult;
    return HorizontalMusicList(songs);
  }
}

