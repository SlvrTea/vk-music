import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/audio_detail_bottom_sheet/widget/audio_tab.dart';
import 'package:vk_music/ui/features/audio_detail_bottom_sheet/widget/bottom_bar.dart';
import 'package:vk_music/ui/features/audio_detail_bottom_sheet/widget/queue_tab.dart';

import 'audio_detail_bottom_sheet_wm.dart';

class AudioDetailBottomSheet extends ElementaryWidget<IAudioDetailBottomSheetWidgetModel> {
  const AudioDetailBottomSheet({super.key}) : super(defaultAudioDetailBottomSheetWidgetModelFactory);

  @override
  Widget build(IAudioDetailBottomSheetWidgetModel wm) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 12),
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                onPressed: wm.onBackTap,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(activeTab: wm.currentTabIndex),
        body: TabBarView(
          controller: wm.tapController,
          children: [
            AudioTab(
              currentAudio: wm.currentAudio,
              playing: wm.isPlaying,
              onRewindTap: wm.onRewindTap,
              onPlayTap: wm.onPlayTap,
              onPauseTap: wm.onPauseTap,
              onForwardTap: wm.onForwardTap,
            ),
            QueueTab(playlist: wm.currentPlaylist),
          ],
        ),
      ),
    );
  }
}
