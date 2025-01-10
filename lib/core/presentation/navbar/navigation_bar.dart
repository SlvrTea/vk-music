import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/state/music_player/music_player_cubit.dart';
import 'audio_bar.dart';

import 'dart:ui';

part 'navigation_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    this.onItemSelected,
    this.backgroundColor,
    this.selectedIndex = 0,
    this.height = 50,
    this.iconSize = 20,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.linear,
    this.shadows = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 3,
      ),
    ],
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final Color? backgroundColor;
  final double height;
  final double iconSize;
  final List<NavBarItem> items;
  final ValueChanged<int>? onItemSelected;
  final int selectedIndex;
  final List<BoxShadow> shadows;

  double iconSizeEffectCalculator(double size) => size > 30
      ? size * 1.2
      : size > 10
          ? size * 0.6
          : 0;

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();

    return Stack(
      // Wrap PreferredSize in Stack
      children: [
        PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(179),
                      Colors.black.withAlpha(230),
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false, // Prevent top spacing
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (musicBloc.state.processingState !=
                          ProcessingState.idle)
                        Container(
                          color:
                              Colors.transparent, // Make container transparent
                          child: const AudioBar(),
                        ),
                      Container(
                        width: double.infinity,
                        height: height + iconSizeEffectCalculator(iconSize),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: items.map((item) {
                            final index = items.indexOf(item);
                            return Expanded(
                                child: GestureDetector(
                              onTap: onItemSelected != null
                                  ? () => onItemSelected!(index)
                                  : null, // Add null check
                              child: _NavBarItem(
                                  item: item,
                                  isSelected: index == selectedIndex,
                                  navHeight: height,
                                  backgroundColor: Colors.transparent,
                                  animationDuration: animationDuration,
                                  animationCurve: animationCurve,
                                  iconSize: iconSize),
                            ));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          // Add this overlay
          bottom: 0,
          left: 0,
          right: 0,
          height: 2, // Small height to cover the line
          child: Container(
            color: Colors.black.withAlpha(230), // Match bottom gradient color
          ),
        ),
      ],
    );
  }
}
