import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

import 'all_songs_wm.dart';

@RoutePage()
class AllArtistSongsScreen extends ElementaryWidget<IAllSongsWidgetModel> {
  const AllArtistSongsScreen({
    super.key,
    required this.artistId,
    required this.initialAudios,
  }) : super(defaultAllSongsWidgetModelFactory);

  final String artistId;
  final List<PlayerAudio> initialAudios;

  @override
  Widget build(IAllSongsWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metric = scrollEnd.metrics;
            if (metric.pixels + 200 >= metric.maxScrollExtent) {
              wm.loadMore();
            }
            return true;
          },
          child: EntityStateNotifierBuilder(
            listenableEntityState: wm.audios,
            loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
            builder: (context, audios) {
              return SingleChildScrollView(
                child: Column(
                  children: audios!
                      .map((e) => AudioTile(
                            audio: e,
                            playlist: audios,
                            withMenu: true,
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
