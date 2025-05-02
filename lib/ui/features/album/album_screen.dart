import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';
import 'package:vk_music/domain/audio_player/audio_player_controller.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

import '../../../data/models/user/user.dart';
import '../../widgets/common/audio_tile.dart';

part 'album_screen_model.dart';
part 'album_screen_wm.dart';

@RoutePage()
class AlbumScreen extends ElementaryWidget<IAlbumScreenWidgetModel> {
  const AlbumScreen({
    super.key,
    required this.playlist,
  }) : super(defaultAlbumScreenWidgetModelFactory);

  final Playlist playlist;

  @override
  Widget build(IAlbumScreenWidgetModel wm) {
    final buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    return Scaffold(
      body: DoubleValueListenableBuilder(
          firstValue: wm.albumItems,
          secondValue: wm.album,
          builder: (context, items, album) {
            if (items.data == null || album.data == null) return const Center(child: CircularProgressIndicator());
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * .3,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(album.data!.photo!.photo270!),
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  wm.theme.colors.backgroundColor.withAlpha(179),
                                  wm.theme.colors.backgroundColor.withAlpha(230),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                album.data!.photo!.photo600!,
                                width: 160,
                                height: 160,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                album.data!.title,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text('${album.data!.plays} прослушиваний'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: wm.playFrom,
                          label: const Text('Слушать'),
                          icon: const Icon(Icons.play_arrow_rounded),
                          style: buttonStyle,
                        ),
                      ),
                      if (album.data!.original == null && album.data!.ownerId.toString() == context.global.user!.userId)
                        ElevatedButton.icon(
                          onPressed: wm.onEditPlaylistTap,
                          label: const Text('Изменить'),
                          icon: const Icon(Icons.edit_rounded),
                          style: buttonStyle,
                        ),
                      if (album.data!.original != null || album.data!.ownerId.toString() != context.global.user!.userId)
                        album.data!.isFollowing
                            ? IconButton.filled(
                                onPressed: wm.onDeletePlaylistTap,
                                icon: const Icon(Icons.check_rounded),
                                constraints: const BoxConstraints(
                                  minWidth: 90,
                                ),
                                style: buttonStyle,
                              )
                            : ElevatedButton.icon(
                                onPressed: wm.onFollowPlaylistTap,
                                icon: const Icon(Icons.add),
                                label: const Text('Добавить'),
                                style: buttonStyle,
                              ),
                    ],
                  ),
                ),
                if (album.data!.description.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      child: Text(album.data!.description,
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                    ),
                  ),
                const SliverToBoxAdapter(child: Divider()),
                if (items.data != null)
                  ...items.data!
                      .map((e) => SliverToBoxAdapter(
                            child: AudioTile(
                              audio: e,
                              playlist: items.data!,
                              withMenu: true,
                            ),
                          ))
                      .toList()
                    ..insert(
                        0,
                        SliverToBoxAdapter(
                          child: ListTile(
                            leading: SizedBox(
                              width: 55,
                              child: Icon(
                                Icons.shuffle_rounded,
                                size: 32,
                                color: wm.theme.accentColor,
                              ),
                            ),
                            title: Text(
                              'Перемешать все',
                              style: wm.theme.c3.copyWith(color: wm.theme.accentColor),
                            ),
                            onTap: wm.playShuffled,
                          ),
                        )),
                SliverToBoxAdapter(child: SizedBox(height: wm.mediaQuery.padding.bottom)),
              ],
            );
          }),
    );
  }
}
