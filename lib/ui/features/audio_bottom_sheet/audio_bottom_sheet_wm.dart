import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/domain/audio_player/audio_player_controller.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import '../../../data/models/playlist/playlist.dart';
import '../../../domain/model/player_audio.dart';
import 'audio_bottom_sheet_model.dart';

abstract interface class IAudioBottomSheetWidgetModel implements IWidgetModel {
  AppAudioPlayerController get player;

  EntityValueListenable<List<PlayerAudio>> get audios;

  EntityValueListenable<List<Playlist>> get ownedPlaylists;

  EntityValueListenable<List<PlayerAudio>> get cachedAudios;

  Future<void> onAddAudioTap();

  Future<void> onDeleteAudioTap();

  void onGoToArtistTap();

  void onAddToPlaylistTap();

  void onFindArtistTap();

  void onGoToAlbumTap();

  void onPlayNextTap();

  void onCacheTap();

  void onDeleteCachedTap();
}

AudioBottomSheetWidgetModel defaultAudioBottomSheetWidgetModelFactory(BuildContext context) =>
    AudioBottomSheetWidgetModel(AudioBottomSheetModel(context.global.audioRepository));

class AudioBottomSheetWidgetModel extends WidgetModel<AudioBottomSheetWidget, IAudioBottomSheetModel>
    implements IAudioBottomSheetWidgetModel {
  AudioBottomSheetWidgetModel(super.model);

  @override
  AppAudioPlayerController get player => context.global.audioPlayer;

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  final _cachedAudioEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  @override
  EntityValueListenable<List<Playlist>> get ownedPlaylists => _playlistsEntity;

  @override
  EntityValueListenable<List<PlayerAudio>> get cachedAudios => _cachedAudioEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(model.userAudiosNotifier.value!);
    _cachedAudioEntity.content(model.cachedAudiosNotifier.value);
    _initAsync();
    super.initWidgetModel();
  }

  Future<void> _initAsync() async {
    final playlists = await model.getPlaylists();
    _playlistsEntity.content(playlists.where((e) => e.original == null).toList());
  }

  @override
  Future<void> onAddAudioTap() async {
    try {
      await model.addAudio(widget.audio);
      if (context.mounted) {
        context.router.maybePop();
        const snackBar = SnackBar(content: Text('Аудиозапись добавлена'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> onDeleteAudioTap() async {
    try {
      await model.deleteAudio(widget.audio);
      if (context.mounted) {
        context.router.maybePop();
        const snackBar = SnackBar(content: Text('Аудиозапись удалена'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  void onAddToPlaylistTap() => context.router.popAndPush(SelectPlaylistRoute(
        song: widget.audio,
        ownedPlaylists: _playlistsEntity.value.data!,
        addToPlaylist: _addToPlaylist,
      ));

  @override
  void onGoToArtistTap() => context.router
    ..popUntil((route) => route is! ModalBottomSheetRoute)
    ..push(ArtistRoute(artistId: widget.audio.mainArtists!.first.id!));

  @override
  void onFindArtistTap() => context.router
    ..popUntil((route) => route is! ModalBottomSheetRoute)
    ..navigate(SearchRoute(initialQuery: widget.audio.artist))
    ..notifyAll();

  Future<void> _addToPlaylist(Playlist playlist, PlayerAudio audio) async {
    try {
      await model.addToPlaylist(playlist, audio);
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> onGoToAlbumTap() async {
    final playlist = await model.getPlaylist(widget.audio);
    if (context.mounted) {
      context.router
        ..popUntil((route) => route is! ModalBottomSheetRoute)
        ..push(AlbumRoute(playlist: playlist));
    }
  }

  @override
  void onPlayNextTap() {
    player.playNext(widget.audio);
    context.maybePop();
  }

  @override
  void onCacheTap() {
    model.cacheAudio(widget.audio);
    context.maybePop();
  }

  @override
  void onDeleteCachedTap() {
    model.deleteCachedAudio(_cachedAudioEntity.value.data!.firstWhere((e) => e.id == widget.audio.id));
    context.maybePop();
  }
}
