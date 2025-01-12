import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/common/styles/app_theme.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

import '../../../data/models/song/song.dart';
import '../../../data/models/user/user.dart';
import '../../../domain/model/player_playlist.dart';
import '../../../domain/state/music_player/music_player_cubit.dart';
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(album.data!.photo!.photo270!),
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
                          onPressed: () {
                            context.read<MusicPlayerCubit>().play(
                                  song: items.data!.first,
                                  playlist: PlayerPlaylist.formSongList(items.data!),
                                );
                          },
                          label: const Text('Слушать'),
                          icon: const Icon(Icons.play_arrow_rounded),
                        ),
                      ),
                      if (album.data!.original == null && album.data!.ownerId.toString() == context.global.user!.userId)
                        ElevatedButton.icon(
                          onPressed: wm.onEditPlaylistTap,
                          label: const Text('Изменить'),
                          icon: const Icon(Icons.edit_rounded),
                        ),
                      if (album.data!.original != null || album.data!.ownerId.toString() != context.global.user!.userId)
                        album.data!.isFollowing
                            ? IconButton.filled(
                                onPressed: wm.onDeletePlaylistTap,
                                icon: const Icon(Icons.check_rounded),
                              )
                            : ElevatedButton.icon(onPressed: wm.onFollowPlaylistTap, label: const Text('Добавить')),
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
                ...items.data!.map((e) => SliverToBoxAdapter(
                      child: AudioTile(
                        song: e,
                        playlist: PlayerPlaylist.formSongList(items.data!),
                        withMenu: true,
                      ),
                    )),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: context.global.audioPlayer.audioSource != null ? kToolbarHeight + 40 : kToolbarHeight,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
