
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/artist/artist_cubit.dart';
import 'package:vk_music/domain/state/song_list.dart';
import 'package:vk_music/presentation/song_list/lazy_load_music_list.dart';

import '../../domain/models/song.dart';

class AllArtistSongs extends StatelessWidget {
  const AllArtistSongs(this.cubit, {super.key});

  final ArtistCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<List<Song>?>(
        valueListenable: ValueNotifier(cubit.state.songs),
        builder: (_, value, __) {
          if (value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                cubit.loadMoreSongs(value.length);
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
