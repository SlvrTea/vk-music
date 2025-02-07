import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/ui/widgets/common/app_drawer.dart';
import 'package:vk_music/ui/widgets/common/horizontal_audio_list.dart';
import 'package:vk_music/ui/widgets/common/playlist_widget.dart';

import '../../../domain/model/player_playlist.dart';
import '../../widgets/common/audio_tile.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'search_screen_wm.dart';

@RoutePage()
class SearchScreen extends ElementaryWidget<ISearchScreenWidgetModel> {
  SearchScreen({super.key, @PathParam('q') this.initialQuery}) : super(defaultSearchScreenWidgetModelFactory);

  String? initialQuery;

  @override
  Widget build(ISearchScreenWidgetModel wm) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.pixels + 200 >= metrics.maxScrollExtent) {
            wm.onLoadMoreRecommendations(offset: wm.recommendations.value.data!.length);
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  controller: wm.searchController,
                  leading: IconButton(
                    onPressed: () {
                      wm.search(query: wm.searchController.text);
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
                  onSubmitted: (query) {
                    wm.search(query: query);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: EntityStateNotifierBuilder(
                listenableEntityState: wm.state,
                loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
                builder: (context, state) {
                  if (state == SearchState.recommendations) {
                    return EntityStateNotifierBuilder(
                      listenableEntityState: wm.recommendations,
                      builder: (context, recs) {
                        final playlist = PlayerPlaylist(children: recs!);
                        return SingleChildScrollView(
                          child: Column(
                            children: [...recs.map((e) => AudioTile(audio: e, playlist: playlist, withMenu: true))],
                          ),
                        );
                      },
                    );
                  } else {
                    return TripleValueListenableBuilder(
                      firstValue: wm.playlists,
                      secondValue: wm.audios,
                      thirdValue: wm.albums,
                      builder: (context, playlists, audios, albums) {
                        if (playlists.data == null || audios.data == null || albums.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Все треки', style: context.global.theme.t2),
                                    TextButton(
                                      onPressed: () => context.router.push(AllSongsRoute(
                                        initialAudios: audios.data!,
                                        query: wm.searchController.text,
                                      )),
                                      child: const Text('Показать все'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: HorizontalMusicList(audios.data!),
                              ),
                              if (playlists.data!.isNotEmpty) ...[
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Все плейлисты', style: context.global.theme.t2),
                                      TextButton(onPressed: wm.onAllPlaylistsTap, child: const Text('Показать все')),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: playlists.data!
                                        .map((e) => PlaylistWidget(
                                              playlist: e,
                                              size: 175,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                              if (albums.data!.isNotEmpty) ...[
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Альбомы', style: context.global.theme.t2),
                                      TextButton(onPressed: wm.onAllAlbumsTap, child: const Text('Показать все')),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: albums.data!
                                        .map((e) => PlaylistWidget(
                                              playlist: e,
                                              size: 175,
                                            ))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: wm.mediaQuery.padding.bottom),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
