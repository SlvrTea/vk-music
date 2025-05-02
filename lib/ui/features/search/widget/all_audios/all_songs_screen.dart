import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/domain/model/player_playlist.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

import 'all_songs_wm.dart';

@RoutePage()
class AllSongsScreen extends ElementaryWidget<IAllSongsWidgetModel> {
  const AllSongsScreen({
    super.key,
    required this.query,
    required this.initialAudios,
  }) : super(defaultAllSongsWidgetModelFactory);

  final String query;
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
              final playlist = PlayerPlaylist(children: audios!);
              return SingleChildScrollView(
                child: Column(
                  children: audios
                      .map((e) => AudioTile(
                            audio: e,
                            playlist: playlist,
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
