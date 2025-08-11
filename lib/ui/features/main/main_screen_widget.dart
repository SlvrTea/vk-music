import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/audio_bar.dart';
import 'package:vk_music/ui/widgets/common/app_drawer.dart';
import 'package:vk_music/ui/widgets/common/custom_app_bar.dart';

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
      extendBodyBehindAppBar: true,
      routes: [
        const AudioRoute(),
        SearchRoute(),
        const AlbumsRoute(),
      ],
      drawer: const AppDrawer(),
      appBarBuilder: (context, router) {
        if (router.isRouteActive(AudioRoute.name) ||
            router.isRouteActive(SearchRoute.name) ||
            router.isRouteActive(AlbumsRoute.name)) {
          return PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => context.router.push(const CachedAudioRoute()),
                ),
              ],
            ),
          );
        }
        return PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).viewPadding.top),
          child: SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
        );
      },
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
