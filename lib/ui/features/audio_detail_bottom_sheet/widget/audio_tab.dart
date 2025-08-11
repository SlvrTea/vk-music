import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:text_marquee/text_marquee.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';

import '../../../widgets/common/media_cover.dart';
import '../../main/widget/navigation_bar/slider_bar.dart';

class AudioTab extends StatelessWidget {
  const AudioTab({
    super.key,
    required this.currentAudio,
    required this.playing,
    required this.onRewindTap,
    required this.onPlayTap,
    required this.onPauseTap,
    required this.onForwardTap,
  });

  final EntityValueListenable<PlayerAudio?> currentAudio;
  final EntityValueListenable<bool?> playing;
  final VoidCallback onRewindTap;
  final VoidCallback onPlayTap;
  final VoidCallback onPauseTap;
  final VoidCallback onForwardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: kToolbarHeight),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: DoubleValueListenableBuilder(
            firstValue: currentAudio,
            secondValue: playing,
            builder: (context, audio, isPlaying) {
              if (audio.data == null || isPlaying.data == null) {
                return CoverWidget(
                  size: MediaQuery.of(context).size.width - 32,
                  borderRadius: BorderRadius.circular(16),
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (audio.data!.album?.thumb?.photo600 != null)
                    AnimatedOpacity(
                      opacity: isPlaying.data! ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: CoverWidget(
                        photoUrl: audio.data!.album?.thumb?.photo600,
                        size: MediaQuery.of(context).size.width - 32,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                  else
                    SizedBox.square(
                        dimension: MediaQuery.of(context).size.width - 32),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.global.theme.colors.backgroundColor
                                .withAlpha(179),
                            context.global.theme.colors.backgroundColor
                                .withAlpha(230),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isPlaying.data!
                        ? MediaQuery.of(context).size.width - 50
                        : MediaQuery.of(context).size.width - 100,
                    height: isPlaying.data!
                        ? MediaQuery.of(context).size.width - 50
                        : MediaQuery.of(context).size.width - 100,
                    child: CoverWidget(
                      photoUrl: audio.data!.album?.thumb?.photo600,
                      size: isPlaying.data!
                          ? MediaQuery.of(context).size.width - 50
                          : MediaQuery.of(context).size.width - 100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        EntityStateNotifierBuilder(
          listenableEntityState: currentAudio,
          builder: (context, audio) {
            if (audio == null) {
              return const _PlaceholderControl();
            }
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
                    child: TextMarquee(
                      audio.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextMarquee(
                      audio.artist,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _RewindButton(seekPrevious: onRewindTap),
                      _PlayButton(
                        isPlaying: playing,
                        play: onPlayTap,
                        pause: onPauseTap,
                      ),
                      _ForwardButton(seekNext: onForwardTap),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isPlaying,
    required this.play,
    required this.pause,
  });

  final EntityValueListenable<bool?> isPlaying;
  final double size = 48;
  final VoidCallback play;
  final VoidCallback pause;

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder(
      listenableEntityState: isPlaying,
      builder: (context, isPlaying) {
        return IconButton(
          onPressed: isPlaying == null
              ? null
              : isPlaying
                  ? pause
                  : play,
          icon: Icon(
              isPlaying ?? false
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: size),
        );
      },
    );
  }
}

class _RewindButton extends StatelessWidget {
  const _RewindButton({required this.seekPrevious});

  final double size = 48;
  final VoidCallback seekPrevious;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: seekPrevious,
        icon: Icon(
          Icons.fast_rewind_rounded,
          size: size,
        ));
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton({required this.seekNext});

  final double size = 48;
  final VoidCallback seekNext;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: seekNext,
      icon: Icon(
        Icons.fast_forward_rounded,
        size: size,
      ),
    );
  }
}

class _PlaceholderControl extends StatelessWidget {
  const _PlaceholderControl();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ProgressBar(
              progress: Duration.zero,
              total: Duration.zero,
              thumbRadius: 6,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TextMarquee(
              'В данный момент ничего не играет',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              '',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.fast_rewind_rounded,
                  size: 48,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.pause_rounded,
                  size: 48,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.fast_forward_rounded,
                  size: 48,
                ),
              ),
            ],
          ),
          Spacer()
        ],
      ),
    );
  }
}
