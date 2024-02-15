
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';
import 'package:vk_music/presentation/playlists_tab/playlist_widget.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/models/playlist.dart';
import '../../domain/models/song.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    final state = (context.watch<SearchCubit>().state as SearchFinishedState);
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text('Альбомы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          _SearchAlbumsWidget(state.playlistsResult),
          _SearchSongsWidget(state.searchResult),
        ]
      )
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
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: playlists.map((e) => PlaylistWidget(playlist: e)).toList(),
      ),
    );
  }
}

class _SearchSongsWidget extends StatelessWidget {
  const _SearchSongsWidget(this.songs, {super.key});
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.map((e) => SongTile(song: e, playlist: PlayerPlaylist.formSongList(songs), withMenu: true)).toList(),
    );
  }
}

