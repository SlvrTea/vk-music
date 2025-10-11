import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/data/models/playlist/cached_playlist.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/cache/cached_audio_model.dart';
import 'package:vk_music/ui/features/cache/cached_audio_widget.dart';

abstract interface class ICachedAudioWidgetModel implements IWidgetModel {
  MediaQueryData get mediaQuery;

  EntityValueListenable<List<PlayerAudio>> get audios;

  EntityValueListenable<List<CachedPlaylist>> get playlists;
}

CachedAudioWidgetModel defaultCachedAudioWidgetModelFactory(
  BuildContext context,
) {
  return CachedAudioWidgetModel(
    CachedAudioModel(audioRepository: context.global.audioRepository),
  );
}

class CachedAudioWidgetModel
    extends WidgetModel<CachedAudioWidget, ICachedAudioModel>
    implements ICachedAudioWidgetModel {
  CachedAudioWidgetModel(super.model);

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  final _playlistsEntity = EntityStateNotifier<List<CachedPlaylist>>();

  @override
  EntityValueListenable<List<CachedPlaylist>> get playlists => _playlistsEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(model.cachedAudioNotifier.value);
    _playlistsEntity.content(model.cachedPlaylistNotifier.value);
    model.cachedAudioNotifier.addListener(_listenAudioChanges);
    model.cachedPlaylistNotifier.addListener(_listenPlaylistChange);
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.cachedAudioNotifier.removeListener(_listenAudioChanges);
    model.cachedPlaylistNotifier.removeListener(_listenPlaylistChange);
    super.dispose();
  }

  void _listenAudioChanges() =>
      _audiosEntity.content(model.cachedAudioNotifier.value);

  void _listenPlaylistChange() =>
      _playlistsEntity.content(model.cachedPlaylistNotifier.value);
}
