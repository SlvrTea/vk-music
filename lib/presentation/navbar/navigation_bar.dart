
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/music_loader/music_loader_cubit.dart';
import 'package:vk_music/domain/state/music_progress/music_progress_cubit.dart';
import 'package:vk_music/presentation/navbar/slider_button.dart';

import '../../domain/state/music_player/music_player_bloc.dart';
part 'navigation_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    this.selectedIndex = 0,
    this.height = 50,
    this.iconSize = 20,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.linear,
    this.shadows = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 3,
      ),
    ],
    required this.items,
    required this.onItemSelected,
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final Color? backgroundColor;
  final double height;
  final double iconSize;
  final List<NavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;
  final List<BoxShadow> shadows;

  double iconSizeEffectCalculator(double size) => size > 30
      ? size * 1.2
      : size > 10
      ? size * 0.6
      : 0;

@override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerBloc>();
    final musicProgress = context.watch<MusicProgressCubit>();
    final background = backgroundColor
        ?? Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: background,
        boxShadow: shadows,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            musicBloc.state.processingState == ProcessingState.idle 
                ? const SizedBox() :
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        child: SliderButton()
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProgressBar(
                          progress: musicProgress.state.currentDuration ?? const Duration(),
                          buffered: musicProgress.state.bufferDuration ?? const Duration(),
                          total: Duration(seconds: int.parse(musicBloc.state.song!.duration)),
                          onSeek: (duration) => musicProgress.seekValue(duration),
                        ),
                      ),
                    ],
                  ),
                ),
            Container(
              width: double.infinity,
              height: height + iconSizeEffectCalculator(iconSize),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  var index = items.indexOf(item);
                  return Expanded(
                      child: GestureDetector(
                        onTap: () => onItemSelected(index),
                        child: _NavBarItem(
                            item: item,
                            isSelected: index == selectedIndex,
                            navHeight: height,
                            backgroundColor: background!,
                            animationDuration: animationDuration,
                            animationCurve: animationCurve,
                            iconSize: iconSize
                        ),
                      )
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
