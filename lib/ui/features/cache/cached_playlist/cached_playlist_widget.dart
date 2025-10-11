import 'dart:io';
import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/data/models/playlist/cached_playlist.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_wm.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

@RoutePage()
class CachedPlaylistWidget extends ElementaryWidget<CachedPlaylistWidgetModel> {
  const CachedPlaylistWidget({super.key, required this.playlist})
    : super(defaultCachedPlaylistWidgetModelFactory);

  final CachedPlaylist playlist;

  @override
  Widget build(CachedPlaylistWidgetModel wm) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: wm.wmMediaQuery.size.height * .3,
          pinned: true,
          stretch: true,
          actions: [
            IconButton(
              onPressed: wm.onMoreTap,
              icon: const Icon(Icons.more_vert),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(
              alignment: Alignment.center,
              children: [
                if (playlist.thumb != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(playlist.thumb!)),
                    ),
                  ),
                if (playlist.thumb != null)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            wm.wmTheme.colors.backgroundColor.withAlpha(179),
                            wm.wmTheme.colors.backgroundColor.withAlpha(230),
                          ],
                        ),
                      ),
                    ),
                  ),
                Column(
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: playlist.thumb != null
                          ? Image.file(
                              File(playlist.thumb!),
                              width: 160,
                              height: 160,
                            )
                          : SizedBox.square(
                              dimension: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: wm.wmTheme.colors.secondary,
                                  child: Icon(
                                    Icons.queue_music_rounded,
                                    size: 120,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        playlist.name,
                        textAlign: TextAlign.center,
                        style: wm.wmTheme.h3,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (playlist.audios.isNotEmpty)
          ...playlist.audios.map(
            (e) => SliverToBoxAdapter(
              child: AudioTile(
                audio: e,
                playlist: playlist.audios,
                withMenu: true,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(height: wm.wmMediaQuery.padding.bottom),
        ),
      ],
    );
  }
}
