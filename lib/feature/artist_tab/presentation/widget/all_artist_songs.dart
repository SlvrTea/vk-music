
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/models/song.dart';
import '../../../song_list/lazy_load_music_list.dart';
import '../../domain/state/artist_cubit.dart';

class AllArtistSongs extends StatelessWidget {
  const AllArtistSongs({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ArtistCubit>();
    List<Song> songs = cubit.state.songs!;
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Song>?>(
        valueListenable: ValueNotifier(songs),
        builder: (_, value, __) {
          if (value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                cubit.loadMoreSongs(value.length);
                songs = cubit.state.songs!;
              }
              return true;
            },
            child: LazyLoadMusicList(songs: value)
          );
        }
      )
    );
  }
}
