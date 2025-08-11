import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/cache/cached_audio_wm.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';
import 'package:vk_music/ui/widgets/common/custom_app_bar.dart';

@RoutePage()
class CachedAudioWidget extends ElementaryWidget<ICachedAudioWidgetModel> {
  const CachedAudioWidget({super.key}) : super(defaultCachedAudioWidgetModelFactory);

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
          if (audios == null) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              return AudioTile(
                audio: audios[index],
                playlist: audios,
                withMenu: true,
              );
            },
          );
        },
      ),
    );
  }
}
