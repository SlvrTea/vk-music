
import 'package:flutter/material.dart';
import 'package:vk_music/domain/models/song.dart';
import 'package:vk_music/domain/state/search/search_cubit.dart';

import '../song_list/lazy_load_music_list.dart';

class AllSongs extends StatelessWidget {
  const AllSongs(this.cubit, {super.key});

  final SearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = (cubit.state as SearchFinishedState);
    List<Song> songs = state.searchResult;
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Song>>(
        valueListenable: ValueNotifier<List<Song>>(songs),
        builder: (_, value, __) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                cubit.loadMore(state.query, offset: value.length);
                songs = state.searchResult;
              }
              return true;
            },
            child: LazyLoadMusicList(songs: value)
          );
        },
      ),
    );
  }
}
