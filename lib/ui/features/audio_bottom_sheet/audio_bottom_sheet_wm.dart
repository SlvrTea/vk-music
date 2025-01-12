import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import '../../../data/models/playlist/playlist.dart';
import '../../../data/models/song/song.dart';
import 'audio_bottom_sheet_model.dart';

abstract interface class IAudioBottomSheetWidgetModel implements IWidgetModel {
  EntityValueListenable<List<Song>> get audios;

  EntityValueListenable<List<Playlist>> get ownedPlaylists;

  Future<void> onAddAudioTap(Song audio);

  Future<void> onDeleteAudioTap(Song audio);

  void onGoToArtistTap(String artistId);

  void onAddToPlaylistTap();

  void onFindArtistTap(Song audio);
}

AudioBottomSheetWidgetModel defaultAudioBottomSheetWidgetModelFactory(BuildContext context) =>
    AudioBottomSheetWidgetModel(AudioBottomSheetModel(context.global.audioRepository));

class AudioBottomSheetWidgetModel extends WidgetModel<AudioBottomSheetWidget, IAudioBottomSheetModel>
    implements IAudioBottomSheetWidgetModel {
  AudioBottomSheetWidgetModel(super.model);

  final _audiosEntity = EntityStateNotifier<List<Song>>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<Song>> get audios => _audiosEntity;

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
  Future<void> onAddAudioTap(Song audio) async {
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
  Future<void> onDeleteAudioTap(Song audio) async {
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
  void onGoToArtistTap(String artistId) => context.router.popAndPush(ArtistRoute(artistId: artistId));

  Future<void> _addToPlaylist(Playlist playlist) async {
    try {
      await model.addToPlaylist(playlist, widget.audio);
      if (context.mounted) {
        final snackBar = SnackBar(
          content: Text('Аудиозапись добавлена в плейлист ${playlist.title}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  void onFindArtistTap(Song audio) {
    context.router
      ..maybePop()
      ..navigate(SearchRoute(initialQuery: audio.artist));
  }
}
