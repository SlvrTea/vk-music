import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/data/models/user/user.dart';
import 'package:vk_music/domain/audio_player/audio_player_controller.dart';

import '../../../domain/model/player_audio.dart';
import 'audio_screen_model.dart';
import 'audio_screen_widget.dart';

abstract interface class IAudioScreenWidgetModel implements IWidgetModel {
  User get user;

  AppAudioPlayerController get player;

  MediaQueryData get mediaQuery;

  EntityValueListenable<List<PlayerAudio>> get audios;

  EntityValueListenable<List<Playlist>> get playlists;

  EntityValueListenable<List<PlayerAudio>> get cachedAudios;

  void onAudioTileTap(int index);

  void onReorder({required int audioId, int? before, int? after});

  void moveAudio(int currentIndex, int newIndex);

  Future<void> loadPlaylists();

  Future<void> loadAudios();
}

AudioScreenWidgetModel defaultAudioScreenWidgetModelFactory(BuildContext context) =>
    AudioScreenWidgetModel(AudioScreenModel(context.global.audioRepository));

class AudioScreenWidgetModel extends WidgetModel<AudioScreen, IAudioScreenModel> implements IAudioScreenWidgetModel {
  AudioScreenWidgetModel(super.model);

  @override
  User get user => context.global.user!;

  @override
  AppAudioPlayerController get player => context.global.audioPlayer;

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  final _cachedAudioEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  @override
  EntityValueListenable<List<Playlist>> get playlists => _playlistsEntity;

  @override
  EntityValueListenable<List<PlayerAudio>> get cachedAudios => _cachedAudioEntity;

  @override
  void onAudioTileTap(int index) {
    final audios = _audiosEntity.value.data ?? [];
    context.global.audioPlayer.playFrom(initialIndex: index, playlist: audios);
  }

  @override
  void moveAudio(int currentIndex, int newIndex) {
    final audios = [..._audiosEntity.value.data!];
    audios.insert(newIndex, audios.removeAt(currentIndex));
    _audiosEntity.content(audios);
  }

  @override
  void onReorder({required int audioId, int? before, int? after}) {
    model.reorder(audioId: audioId, before: before, after: after);
  }

  @override
  void initWidgetModel() {
    model.userAudiosNotifier.addListener(_listenAudioChanges);
    model.userPlaylistsNotifier.addListener(_listenPlaylistsChanges);
    model.cachedAudioNotifier.addListener(_listenCacheChanges);
    model.loadCachedAudio();

    _initAsync();
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.userAudiosNotifier.removeListener(_listenAudioChanges);
    model.userPlaylistsNotifier.removeListener(_listenPlaylistsChanges);
    model.cachedAudioNotifier.removeListener(_listenCacheChanges);
    super.dispose();
  }

  Future<void> _initAsync() async {
    await Future.wait([
      loadAudios(),
      loadPlaylists(),
    ]);
  }

  @override
  Future<void> loadAudios() async {
    _audiosEntity.loading();
    model.getAudios(context.global.user!.userId.toString());
  }

  @override
  Future<void> loadPlaylists() async {
    try {
      _playlistsEntity.loading();
      final res = await model.getPlaylists();
      _playlistsEntity.content(res);
    } catch (e) {
      _playlistsEntity.content([]);
      _showError('Ошибка при получении плейлистов: $e');
      rethrow;
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  void _listenAudioChanges() => _audiosEntity.content(model.userAudiosNotifier.value!);

  void _listenPlaylistsChanges() => _playlistsEntity.content(model.userPlaylistsNotifier.value!);

  void _listenCacheChanges() => _cachedAudioEntity.content(model.cachedAudioNotifier.value);
}
