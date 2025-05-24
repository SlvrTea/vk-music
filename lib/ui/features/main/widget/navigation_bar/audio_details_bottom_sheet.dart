import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/slider_bar.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

import '../../../../widgets/common/media_cover.dart';
import 'audio_buttons.dart';

class AudioDetailBottomSheet extends StatelessWidget {
  const AudioDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 12),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              onPressed: () => context.maybePop(),
            ),
          ),
        ),
      ),
      body: const DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: TabBarView(
          children: [_MainBody(), _MusicList()],
        ),
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: kToolbarHeight,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: _Cover(),
        ),
        _Control(),
      ],
    );
  }
}

class _Cover extends StatefulWidget {
  const _Cover();

  @override
  State<_Cover> createState() => _CoverState();
}

class _CoverState extends State<_Cover> {
  bool minimizeCover = false;
  PlayerAudio? audio;

  void _listenState() =>
      setState(() {
        minimizeCover = !context.global.audioPlayer.playing!;
        audio = context.global.audioPlayer.currentAudio;
      });

  @override
  void initState() {
    minimizeCover = !context.global.audioPlayer.playing!;
    audio = context.global.audioPlayer.currentAudio;
    context.global.audioPlayer.addListener(_listenState);
    super.initState();
  }

  @override
  void dispose() {
    context.global.audioPlayer.removeListener(_listenState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (audio!.album?.thumb?.photo600 != null && !minimizeCover)
          CoverWidget(
            photoUrl: audio!.album?.thumb?.photo600,
            size: MediaQuery
                .of(context)
                .size
                .width - 32,
            borderRadius: BorderRadius.circular(16),
          )
        else
          SizedBox.square(dimension: MediaQuery
              .of(context)
              .size
              .width - 32),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.global.theme.colors.backgroundColor.withAlpha(179),
                  context.global.theme.colors.backgroundColor.withAlpha(230),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.ease,
            width: minimizeCover ? MediaQuery
                .of(context)
                .size
                .width - 100 : MediaQuery
                .of(context)
                .size
                .width - 50,
            height: minimizeCover ? MediaQuery
                .of(context)
                .size
                .width - 100 : MediaQuery
                .of(context)
                .size
                .width - 50,
            child: CoverWidget(
              photoUrl: audio!.album?.thumb?.photo600,
              size: minimizeCover ? MediaQuery
                  .of(context)
                  .size
                  .width - 100 : MediaQuery
                  .of(context)
                  .size
                  .width - 50,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _Control extends StatelessWidget {
  const _Control();

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        final audio = player.currentAudio!;
        return Expanded(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SliderBar(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  audio.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, overflow: TextOverflow.ellipsis),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  audio.artist,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MusicBarPreviousAudioButton(size: 48),
                  MusicBarPlayButton(size: 48),
                  MusicBarNextAudioButton(size: 48)
                ],
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ShuffleButton(), LoopModeButton()],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MusicList extends StatelessWidget {
  const _MusicList();

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: kToolbarHeight)),
          ListenableBuilder(
            listenable: player,
            builder: (context, _) {
              final playlist = player.currentPlaylist;
              return SliverReorderableList(
                itemCount: playlist!.length,
                itemBuilder: (context, index) {
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    child: AudioTile(
                      audio: player.shuffleModeEnabled ? playlist[player.shuffleIndices[index]] : playlist[index],
                      playlist: playlist,
                      withMenu: true,
                    ),
                  );
                },
                onReorder: player.move,
                proxyDecorator: _proxyDecorator,
              );
            },
          ),
        ],
      ),
    );
  }
}
