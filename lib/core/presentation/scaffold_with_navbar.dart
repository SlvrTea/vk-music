
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vk_music/core/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/core/presentation/navbar/navigation_bar.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({required this.child, this.appBar, super.key});

  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final navigationCubit = context.watch<NavBarCubit>();
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: NavBar(
        items: [
          NavBarItem(icon: const Icon(Icons.music_note_rounded), route: '/audios'),
          NavBarItem(icon: const Icon(Icons.search), route: '/search'),
          NavBarItem(icon: const Icon(Icons.album), route: '/playlists')
        ],
        selectedIndex: navigationCubit.state,
        onItemSelected: (item, index) {
          context.go(item.route);
          navigationCubit.changeTab(index);
        }
      ),
    );
  }
}
