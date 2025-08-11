import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/cache/cached_audio_model.dart';
import 'package:vk_music/ui/features/cache/cached_audio_widget.dart';

abstract interface class ICachedAudioWidgetModel implements IWidgetModel {
  EntityValueListenable<List<PlayerAudio>> get audios;
}

CachedAudioWidgetModel defaultCachedAudioWidgetModelFactory(BuildContext context) {
  return CachedAudioWidgetModel(CachedAudioModel(audioRepository: context.global.audioRepository));
}

class CachedAudioWidgetModel extends WidgetModel<CachedAudioWidget, ICachedAudioModel>
    implements ICachedAudioWidgetModel {
  CachedAudioWidgetModel(super.model);

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(model.cachedAudioNotifier.value);
    model.cachedAudioNotifier.addListener(_listenAudioChanges);
    super.initWidgetModel();
  }

  @override
  void dispose() {
    model.cachedAudioNotifier.removeListener(_listenAudioChanges);
    super.dispose();
  }

  void _listenAudioChanges() => _audiosEntity.content(model.cachedAudioNotifier.value);
}
