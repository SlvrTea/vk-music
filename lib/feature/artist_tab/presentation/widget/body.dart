
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/models/player_playlist.dart';
import '../../../../core/domain/state/music_player/music_player_cubit.dart';
import '../../../playlist_tab/presentation/widget/playlist_widget.dart';
import '../../../song_list/horizontal_music_list.dart';
import '../../domain/state/artist_cubit.dart';
import 'all_artist_albums.dart';
import 'all_artist_playlists.dart';
import 'all_artist_songs.dart';

class ArtistTabBody extends StatelessWidget {
  const ArtistTabBody(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    const imageBorders = BorderRadius.only(
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8)
    );
    final cubit = ArtistCubit()
      ..getArtist(id);
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<ArtistCubit, ArtistState>(
        builder: (context, state) {
          if (state.artist == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * .33,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(state.artist!.name),
                  background: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: imageBorders,
                        child: Image.network(state.artistAlbums!.first.photoUrl1200!, fit: BoxFit.cover)
                      ),
                      Align(
                        alignment: const Alignment(0, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FloatingActionButton(
                                onPressed: () => context.read<MusicPlayerCubit>()
                                    .play(song: state.songs!.first, playlist: PlayerPlaylist.formSongList(state.songs!)),
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                                child: const Icon(Icons.play_arrow_rounded, size: 42),
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                  ),
                )
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Популярное', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            // TODO: перенести на новый роутер
                            // navigatorKey.currentState!
                            //     .push(MaterialPageRoute(builder: (_) => const AllArtistSongs()));
                            // cubit.loadMoreSongs(cubit.state.songs!.length);
                          },
                          child: const Text('Показать все')
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HorizontalMusicList(state.songs!),
                  ),
                  if (state.artistAlbums != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Релизы', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              // TODO: перенести на новый роутер
                              // navigatorKey.currentState!
                              //     .push(MaterialPageRoute(builder: (_) => AllArtistAlbums(cubit)));
                            },
                            child: const Text('Показать все')
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.artistAlbums!
                            .map((e) => PlaylistWidget(playlist: e, size: MediaQuery.of(context).size.width * .4)).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Встречается в плейлистах', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              // TODO: перенести на новый роутер
                              // navigatorKey.currentState!
                              //     .push(MaterialPageRoute(builder: (_) => AllArtistPlaylists(cubit)));
                            },
                            child: const Text('Показать все')
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.playlists!
                            .map((e) => PlaylistWidget(playlist: e, size: MediaQuery.of(context).size.width * .4)).toList(),
                      ),
                    ),
                  ],
                ])
              ),
            ]
          );
        },
      ),
    );
  }
}
