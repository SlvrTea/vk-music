import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/cache/cached_audio_wm.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';
import 'package:vk_music/ui/widgets/common/custom_app_bar.dart';

@RoutePage()
class CachedAudioWidget extends ElementaryWidget<ICachedAudioWidgetModel> {
  const CachedAudioWidget({super.key})
    : super(defaultCachedAudioWidgetModelFactory);

  @override
  Widget build(ICachedAudioWidgetModel wm) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      extendBodyBehindAppBar: true,
      body: EntityStateNotifierBuilder(
        listenableEntityState: wm.audios,
        builder: (context, audios) {
          if (audios == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: wm.mediaQuery.padding.top + 8 + kToolbarHeight,
                ),
              ),
              SliverToBoxAdapter(
                child: EntityStateNotifierBuilder(
                  listenableEntityState: wm.playlists,
                  builder: (context, playlists) {
                    if (playlists == null || playlists.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 149,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: playlists
                              .map(
                                (e) => SizedBox(
                                  width: 131,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: null,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox.square(
                                          dimension: 115,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.file(
                                                  File(e.thumb!),
                                                  width: 115,
                                                  height: 115,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            e.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverList.builder(
                itemCount: audios.length,
                itemBuilder: (context, index) {
                  return AudioTile(
                    audio: audios[index],
                    playlist: audios,
                    withMenu: true,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: wm.mediaQuery.padding.bottom),
              ),
            ],
          );
        },
      ),
    );
  }
}
