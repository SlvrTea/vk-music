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
  AppAudioPlayer get player;

  EntityValueListenable<List<PlayerAudio>> get audios;

  EntityValueListenable<List<Playlist>> get ownedPlaylists;

  Future<void> onAddAudioTap(PlayerAudio audio);

  Future<void> onDeleteAudioTap(PlayerAudio audio);

  void onGoToArtistTap(String artistId);

  void onAddToPlaylistTap();

  void onFindArtistTap(PlayerAudio audio);

  void onGoToAlbumTap(PlayerAudio audio);

  void onPlayNextTap(PlayerAudio audio);
}

AudioBottomSheetWidgetModel defaultAudioBottomSheetWidgetModelFactory(BuildContext context) =>
    AudioBottomSheetWidgetModel(AudioBottomSheetModel(context.global.audioRepository));

class AudioBottomSheetWidgetModel extends WidgetModel<AudioBottomSheetWidget, IAudioBottomSheetModel>
    implements IAudioBottomSheetWidgetModel {
  AudioBottomSheetWidgetModel(super.model);

  @override
  AppAudioPlayer get player => context.global.audioPlayer;

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  @override
  EntityValueListenable<List<Playlist>> get ownedPlaylists => _playlistsEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(model.userAudiosNotifier.value!);
    _initAsync();
    super.initWidgetModel();
  }

  Future<void> _initAsync() async {
    final playlists = await model.getPlaylists();
    _playlistsEntity.content(playlists.where((e) => e.original == null).toList());
  }

  @override
  Future<void> onAddAudioTap(PlayerAudio audio) async {
    try {
      await model.addAudio(audio);
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
  Future<void> onDeleteAudioTap(PlayerAudio audio) async {
    try {
      await model.deleteAudio(audio);
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
  void onGoToArtistTap(String artistId) => context.router
    ..popUntil((route) => route is! ModalBottomSheetRoute)
    ..push(ArtistRoute(artistId: artistId));

  @override
  void onFindArtistTap(PlayerAudio audio) => context.router
    ..popUntil((route) => route is! ModalBottomSheetRoute)
    ..navigate(SearchRoute(initialQuery: audio.artist))
    ..notifyAll();

  Future<void> _addToPlaylist(Playlist playlist, PlayerAudio audio) async {
    try {
      await model.addToPlaylist(playlist, audio);
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> onGoToAlbumTap(PlayerAudio audio) async {
    final playlist = await model.getPlaylist(audio);
    if (context.mounted) {
      context.router
        ..popUntil((route) => route is! ModalBottomSheetRoute)
        ..push(AlbumRoute(playlist: playlist));
    }
  }

  @override
  void onPlayNextTap(PlayerAudio audio) {
    player.playNext(audio);
    context.maybePop();
  }
}
