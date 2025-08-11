import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

import 'albums_screen_model.dart';
import 'albums_screen_widget.dart';

abstract interface class IAlbumsScreenWidgetModel implements IWidgetModel {
  MediaQueryData get mediaQuery;

  AppTheme get theme;

  EntityValueListenable<List<Playlist>> get playlists;

  Future<void> createAlbum();
}

AlbumsScreenWidgetModel defaultAlbumsScreenWidgetModelFactory(BuildContext context) =>
    AlbumsScreenWidgetModel(AlbumsScreenModel(
      context.global.audioRepository,
    ));

class AlbumsScreenWidgetModel extends WidgetModel<AlbumsScreen, IAlbumsScreenModel>
    implements IAlbumsScreenWidgetModel {
  AlbumsScreenWidgetModel(super.model);

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  @override
  AppTheme get theme => wmTheme;

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<Playlist>> get playlists => _playlistsEntity;

  @override
  void initWidgetModel() {
    _playlistsEntity.content(model.userPlaylistsNotifier.value!);
    model.userPlaylistsNotifier.addListener(_listenPlaylistsChange);
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.userPlaylistsNotifier.removeListener(_listenPlaylistsChange);
    super.dispose();
  }

  @override
  Future<void> createAlbum() async {
    final res = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog.adaptive(
          title: const Text('Создать плейлист'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.maybePop(controller.text);
              },
              child: const Text('Создать'),
            )
          ],
        );
      },
    );
    if (res != null) {
      await model.createAlbum(res);
    }
  }

  void _listenPlaylistsChange() => _playlistsEntity.content(model.userPlaylistsNotifier.value!);
}
