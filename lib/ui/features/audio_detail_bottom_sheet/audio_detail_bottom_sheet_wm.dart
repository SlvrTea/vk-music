import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';
import 'package:vk_music/domain/audio_player/audio_player_controller.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

import 'audio_detail_bottom_sheet.dart';
import 'audio_detail_bottom_sheet_model.dart';

abstract interface class IAudioDetailBottomSheetWidgetModel implements IWidgetModel {
  AppTheme get theme;

  MediaQueryData get mediaQuery;

  TabController get tapController;

  EntityValueListenable<PlayerAudio?> get currentAudio;

  EntityValueListenable<List<PlayerAudio>?> get currentPlaylist;

  EntityValueListenable<bool?> get isPlaying;

  EntityValueListenable<int> get currentTabIndex;

  void onBackTap();

  void onRewindTap();

  void onForwardTap();

  void onPlayTap();

  void onPauseTap();
}

AudioDetailBottomSheetWidgetModel defaultAudioDetailBottomSheetWidgetModelFactory(BuildContext context) =>
    AudioDetailBottomSheetWidgetModel(AudioDetailBottomSheetModel());

class AudioDetailBottomSheetWidgetModel extends WidgetModel<AudioDetailBottomSheet, IAudioDetailBottomSheetModel>
    with TickerProviderWidgetModelMixin
    implements IAudioDetailBottomSheetWidgetModel {
  AudioDetailBottomSheetWidgetModel(super.model);

  @override
  AppTheme get theme => wmTheme;

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  @override
  TabController get tapController => _tabController;
  late final TabController _tabController;

  @override
  EntityValueListenable<PlayerAudio?> get currentAudio => _currentAudioEntity;
  final _currentAudioEntity = EntityStateNotifier<PlayerAudio?>();

  @override
  EntityValueListenable<List<PlayerAudio>?> get currentPlaylist => _currentPlaylistEntity;
  final _currentPlaylistEntity = EntityStateNotifier<List<PlayerAudio>?>();

  @override
  EntityValueListenable<bool?> get isPlaying => _isPlayingEntity;
  final _isPlayingEntity = EntityStateNotifier<bool?>();

  @override
  EntityValueListenable<int> get currentTabIndex => _currentTabIndexEntity;
  final _currentTabIndexEntity = EntityStateNotifier<int>();

  late final AppAudioPlayerController _player;

  @override
  void initWidgetModel() {
    _player = context.global.audioPlayer;
    _tabController = TabController(length: 2, vsync: this, animationDuration: Duration.zero)..addListener(_listenTab);
    _currentTabIndexEntity.content(_tabController.index);
    _isPlayingEntity.content(_player.playing);
    _currentAudioEntity.content(_player.currentAudio);
    _currentPlaylistEntity.content(_player.currentPlaylist);
    _player.addListener(_listenAudioPlayer);
    super.initWidgetModel();
  }

  @override
  void dispose() {
    _player.removeListener(_listenAudioPlayer);
    tapController.removeListener(_listenTab);
    tapController.dispose();
    super.dispose();
  }

  @override
  void onBackTap() => context.router.maybePop();

  @override
  void onForwardTap() => _player.seekToNext();

  @override
  void onPlayTap() => _player.play();

  @override
  void onRewindTap() => _player.seekToPrevious();

  @override
  void onPauseTap() => _player.pause();

  void _listenAudioPlayer() {
    _isPlayingEntity.content(_player.playing);
    _currentAudioEntity.content(_player.currentAudio);
    _currentPlaylistEntity.content(_player.currentPlaylist);
  }

  void _listenTab() => _currentTabIndexEntity.content(_tabController.index);
}
