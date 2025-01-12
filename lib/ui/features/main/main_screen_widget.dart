import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/state/music_player/music_player_cubit.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/audio_bar.dart';

import '../../../common/utils/router/app_router.dart';
import 'widget/navigation_bar/navigation_bar.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MusicPlayerCubit>();
    return AutoTabsScaffold(
      extendBody: true,
      routes: [
        const AudioRoute(),
        SearchRoute(),
        const AlbumsRoute(),
      ],
      bottomNavigationBuilder: (context, router) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
            child: Container(
              decoration: BoxDecoration(
                color: context.global.theme.colors.backgroundColor.withOpacity(0.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cubit.state.song != null) const AudioBar(),
                  NavBar(
                    selectedIndex: router.activeIndex,
                    onItemSelected: router.setActiveIndex,
                    backgroundColor: Colors.transparent,
                    items: [
                      NavBarItem(icon: const Icon(Icons.music_note_rounded)),
                      NavBarItem(icon: const Icon(Icons.search_rounded)),
                      NavBarItem(icon: const Icon(Icons.album_rounded)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
