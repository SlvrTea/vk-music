import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/data/models/user/user.dart';
import 'package:vk_music/domain/model/player_playlist.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';

import '../../../data/models/song/song.dart';
import 'audio_screen_model.dart';
import 'audio_screen_widget.dart';

abstract interface class IAudioScreenWidgetModel implements IWidgetModel {
  User get user;

  EntityValueListenable<List<Song>> get audios;

  EntityValueListenable<List<Playlist>> get playlists;

  void onAudioTileTap(int index);

  Future<void> loadPlaylists();

  Future<void> loadAudios();
}

AudioScreenWidgetModel defaultAudioScreenWidgetModelFactory(BuildContext context) =>
    AudioScreenWidgetModel(AudioScreenModel(context.global.audioRepository));

class AudioScreenWidgetModel extends WidgetModel<AudioScreen, IAudioScreenModel> implements IAudioScreenWidgetModel {
  AudioScreenWidgetModel(super.model);

  @override
  User get user => context.global.user!;

  late final MusicPlayerCubit playerCubit;

  final _audiosEntity = EntityStateNotifier<List<Song>>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<Song>> get audios => _audiosEntity;

  @override
  EntityValueListenable<List<Playlist>> get playlists => _playlistsEntity;

  @override
  void onAudioTileTap(int index) {
    final audios = _audiosEntity.value.data ?? [];
    playerCubit.play(song: audios[index], playlist: PlayerPlaylist.formSongList(audios));
  }

  @override
  void initWidgetModel() {
    model.userAudiosNotifier.addListener(_listenAudioChanges);
    model.userPlaylistsNotifier.addListener(_listenPlaylistsChanges);

    playerCubit = context.watch<MusicPlayerCubit>();
    _initAsync();
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.userAudiosNotifier.removeListener(_listenAudioChanges);
    model.userPlaylistsNotifier.removeListener(_listenPlaylistsChanges);
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
}
