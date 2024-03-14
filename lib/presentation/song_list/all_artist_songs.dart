
import 'package:flutter/material.dart';
import 'package:vk_music/domain/state/artist/artist_cubit.dart';
import 'package:vk_music/presentation/song_list/lazy_load_music_list.dart';

class AllArtistSongs extends StatelessWidget {
  const AllArtistSongs(this.cubit, {super.key});

  final ArtistCubit cubit;

  @override
  Widget build(BuildContext context) {
    final stream = cubit.stream;
    return Scaffold(
      appBar: AppBar(title: Text(cubit.state.artist!.name)),
      body: StreamBuilder(
        stream: stream,
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
                cubit.loadMoreSongs(snapshot.data!.artistSongs!.length);
              }
              return true;
            },
            child:  LazyLoadMusicList(songs: snapshot.data!.artistSongs!)
          );
        },
      ),
    );
  }
}
