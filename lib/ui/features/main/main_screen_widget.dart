import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/audio_bar.dart';

import '../../../common/utils/router/app_router.dart';
import 'widget/navigation_bar/navigation_bar.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.global.audioPlayer;
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
              child: ListenableBuilder(
                  listenable: player,
                  builder: (context, _) {
                    final audio = player.currentAudio;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (audio != null) const AudioBar(),
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
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
