import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';

import 'albums_screen_model.dart';
import 'albums_screen_widget.dart';

abstract interface class IAlbumsScreenWidgetModel implements IWidgetModel {
  EntityValueListenable<List<Playlist>> get playlists;
}

AlbumsScreenWidgetModel defaultAlbumsScreenWidgetModelFactory(BuildContext context) =>
    AlbumsScreenWidgetModel(AlbumsScreenModel(
      context.global.audioRepository,
    ));

class AlbumsScreenWidgetModel extends WidgetModel<AlbumsScreen, IAlbumsScreenModel>
    implements IAlbumsScreenWidgetModel {
  AlbumsScreenWidgetModel(super.model);

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

  void _listenPlaylistsChange() => _playlistsEntity.content(model.userPlaylistsNotifier.value!);
}
