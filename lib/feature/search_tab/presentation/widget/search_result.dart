
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/const.dart';
import '../../../../core/domain/models/playlist.dart';
import '../../../playlist_tab/presentation/widget/playlist_widget.dart';
import '../../../song_list/horizontal_music_list.dart';
import '../../domain/state/search_cubit.dart';
import 'all_albums.dart';
import 'all_playlists.dart';
import 'all_songs.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final state = cubit.state;
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
                  //TODO: fix
                  // navigatorKey.currentState!
                  //     .push(MaterialPageRoute(builder: (_) => AllSongs(cubit)));
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
        if (state.albums != null && state.albums!.isNotEmpty) ...[
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
                    //TODO: fix
                    // navigatorKey.currentState!
                    //     .push(MaterialPageRoute(builder: (_) => AllAlbums(cubit)));
                  },
                  child: const Text('Показать все')
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _SearchAlbumsWidget(state.albums!),
          ),
        ],
        if (state.playlists!.isNotEmpty) ...[
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
                    // TODO: fix
                    // navigatorKey.currentState!
                    //     .push(MaterialPageRoute(builder: (_) => AllPlaylists(cubit)));
                  },
                  child: const Text('Показать все')
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _SearchAlbumsWidget(state.playlists!),
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
    final songs = context.watch<SearchCubit>().state.songs!;
    return HorizontalMusicList(songs);
  }
}

