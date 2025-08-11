import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/ui/features/album/widget/edit_playlist/edit_playlist_screen.dart';

import '../../../../../domain/model/player_audio.dart';
import 'edit_playlist_model.dart';

abstract interface class IEditPlaylistWidgetModel implements IWidgetModel {
  TextEditingController get titleController;

  TextEditingController get descriptionController;

  MediaQueryData get mediaQuery;

  EntityValueListenable<List<PlayerAudio>> get audios;

  void navigateBack();

  void onReorder(PlayerAudio audio, int toIndex);

  void onIconsTap(PlayerAudio audio);

  bool isAdded(PlayerAudio audio);

  Future<void> onAddAudioTap();

  Future<void> saveChanges();
}

EditPlaylistWidgetModel defaultEditPlaylistWidgetModelFactory(BuildContext context) =>
    EditPlaylistWidgetModel(EditPlaylistModel(context.global.audioRepository));

class EditPlaylistWidgetModel extends WidgetModel<EditPlaylistScreen, IEditPlaylistModel>
    implements IEditPlaylistWidgetModel {
  EditPlaylistWidgetModel(super.model);

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  TextEditingController get titleController => _titleController;

  @override
  TextEditingController get descriptionController => _descriptionController;

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  final List<List<int>> _reorder = [];

  final List<String> _toRemove = [];

  final List<String> _toAdd = [];

  @override
  void initWidgetModel() {
    _titleController.text = widget.playlist.title;
    _descriptionController.text = widget.playlist.description;
    _initAsync();
    super.initWidgetModel();
  }

  @override
  void navigateBack() => context.router.maybePop(false);

  @override
  void onReorder(PlayerAudio audio, int toIndex) {
    final reorderFormat = [audio.ownerId, audio.id, toIndex];
    for (int i = 0; i < _reorder.length; i++) {
      if (_reorder[i][0] == audio.id) {
        _reorder.removeAt(i);
      }
    }
    _reorder.add(reorderFormat);
    final audios = [..._audiosEntity.value.data!];
    audios.insert(toIndex, audios.removeAt(audios.indexOf(audio)));
    _audiosEntity.content(audios);
  }

  @override
  Future<void> saveChanges() async {
    final removeCompleter = Completer<void>();
    final saveCompleter = Completer<void>();
    if (_toRemove.isNotEmpty) {
      await model
          .removeFromPlaylist(
            playlistId: widget.playlist.id,
            ownerId: widget.playlist.ownerId,
            audioIds: _toRemove,
          )
          .then((e) => removeCompleter.complete());
    }
    await model
        .save(widget.playlist, _titleController.text, _descriptionController.text, _toAdd, _reorder)
        .then((e) => saveCompleter.complete());
    if (context.mounted && saveCompleter.isCompleted && _toRemove.isEmpty ? true : removeCompleter.isCompleted) {
      await context.router.maybePop(true);
    }
  }

  Future<void> _initAsync() async {
    await Future.wait([
      _loadAudios(),
    ]);
  }

  Future<void> _loadAudios() async {
    final res = await model.getPlaylistAudios(widget.playlist);
    _audiosEntity.content(res);
  }

  @override
  void onIconsTap(PlayerAudio audio) {
    final format = '${audio.ownerId}_${audio.id}';
    if (_toRemove.contains(format)) {
      _toRemove.remove(format);
      return;
    }
    if (_toAdd.contains(format)) {
      _toAdd.remove(format);
    }
    _toRemove.add(format);
  }

  @override
  Future<void> onAddAudioTap() async {
    if (_audiosEntity.value.data == null) return;
    // Audios without items marked to remove. We need this because any item in [AddAudiosScreen.playlistAudios] marked
    // as playlist item.
    final audios =
        [..._audiosEntity.value.data!].where((e) => !_toRemove.any((i) => i.contains(e.id.toString()))).toList();

    final res = await context.router.push<List<PlayerAudio>>(AddAudioRoute(playlistAudios: audios));

    if (res != null) {
      // Indices that user marked as removed, but added them again on [AddAudioScreen]
      final removeIndices = <int>[];

      for (int i = 0; i < _toRemove.length; i++) {
        if (res.any((e) => _toRemove[i].contains(e.id.toString()))) {
          removeIndices.add(i);
        }
      }

      for (final e in removeIndices) {
        _toRemove.removeAt(e);
      }

      // If res contains any audio, that already in playlist, we need to mark that as removed
      _toRemove.addAll(res.where((e) => audios.any((audio) => audio.id == e.id)).map((e) => '${e.ownerId}_${e.id}'));

      _toAdd.addAll(res
          .where((e) => !_toRemove.any((id) => id.contains(e.id.toString())))
          .map((e) => '${e.ownerId}_${e.id}_${e.accessKey}'));

      _audiosEntity
          .content([...res.where((e) => !_audiosEntity.value.data!.any((audio) => audio.id == e.id)), ...audios]);
    }
  }

  @override
  bool isAdded(PlayerAudio audio) => !_toRemove.any((e) => e.contains(audio.id.toString()));
}
