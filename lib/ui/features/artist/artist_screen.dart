import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/widgets/common/playlist_widget.dart';

import '../../widgets/common/horizontal_audio_list.dart';
import 'artist_screen_wm.dart';

@RoutePage()
class ArtistScreen extends ElementaryWidget<IArtistScreenWidgetModel> {
  const ArtistScreen(this.artistId, {super.key}) : super(defaultArtistScreenWidgetModelFactory);

  final String artistId;

  @override
  Widget build(IArtistScreenWidgetModel wm) {
    return Scaffold(
      body: SafeArea(
        child: TripleValueListenableBuilder(
          firstValue: wm.artist,
          secondValue: wm.audios,
          thirdValue: wm.albums,
          builder: (context, artist, audios, albums) {
            if (artist.data == null || audios.data == null || albums.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * .33,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      artist.data!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            albums.data!.first.photo!.photo1200!,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.play_arrow_rounded, size: 42),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Популярное'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Показать все'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: HorizontalMusicList(audios.data!),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Релизы'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Показать все'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: albums.data!.map((e) => PlaylistWidget(playlist: e)).toList(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: EntityStateNotifierBuilder(
                    listenableEntityState: wm.playlists,
                    loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
                    builder: (context, playlists) {
                      if (playlists == null) return const SizedBox.shrink();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Встречается в плейлистах'),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Показать все'),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: playlists.map((e) => PlaylistWidget(playlist: e)).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
