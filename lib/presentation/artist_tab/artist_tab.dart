import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/domain/state/artist/artist_cubit.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';
import 'package:vk_music/presentation/playlists_tab/playlist_widget.dart';
import 'package:vk_music/presentation/song_list/music_list.dart';

class ArtistTab extends StatelessWidget {
  const ArtistTab(this.artistId, {super.key});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _BodyWidget(artistId)),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget(this.id, {super.key});

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
                                    .play(song: state.artistSongs!.first, playlist: PlayerPlaylist.formSongList(state.artistSongs!)),
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
              if (state.artistAlbums != null) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Релизы', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
                  ),
                ),
                SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.artistAlbums!
                            .map((e) => PlaylistWidget(playlist: e)).toList(),
                      ),
                    )
                ),
              ],
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Популярное', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                ),
              ),
              SliverToBoxAdapter(
                child: MusicList(songs: state.artistSongs!, withMenu: true),
              ),
            ]
          );
        },
      ),
    );
  }
}
