
import 'package:flutter/material.dart';

import '../../../../core/domain/models/song.dart';
import '../../../song_list/lazy_load_music_list.dart';
import '../../domain/state/search_cubit.dart';

class AllSongs extends StatelessWidget {
  const AllSongs(this.cubit, {super.key});

  final SearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = cubit.state;
    List<Song> songs = state.songs!;
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Song>>(
        valueListenable: ValueNotifier<List<Song>>(songs),
        builder: (_, value, __) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                cubit.loadMore(state.query!, offset: value.length);
                songs = state.songs!;
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
