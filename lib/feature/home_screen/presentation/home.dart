import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/feature/home_screen/presentation/widget/body.dart';

import '../../../core/domain/state/nav_bar/nav_bar_cubit.dart';
import '../../../core/presentation/navbar/navigation_bar.dart';
import '../../auth/domain/state/auth_bloc.dart';
import '../../auth/presentation/login_screen.dart';
import '../../playlists_tab/presentation/playlists_tab.dart';
import '../../search_tab/presentation/search_tab.dart';

import 'dart:ui'; // For ImageFilter

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final tabs = const [HomeTabBody(), SearchTab(), PlaylistsTab()];

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'VK Music';
      case 1:
        return 'Поиск';
      case 2:
        return 'Плейлисты';
      default:
        return 'VK Music';
    }
  }

  @override
  Widget build(BuildContext context) {
    final navBarCubit = context.watch<NavBarCubit>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              scrolledUnderElevation: 0, // Add this
              surfaceTintColor: Colors.transparent, // Add this
              title: Text(_getTitle(navBarCubit.state)),
              backgroundColor: Colors.black.withAlpha(179),
            ),
          ),
        ),
      ),
      body: tabs[navBarCubit.state],
      drawer: const _Drawer(),
      bottomNavigationBar: NavBar(
        onItemSelected: (index) => navBarCubit.changeTab(index),
        selectedIndex: navBarCubit.state,
        items: [
          NavBarItem(icon: const Icon(Icons.music_note_rounded)),
          NavBarItem(icon: const Icon(Icons.search)),
          NavBarItem(icon: const Icon(Icons.album))
        ],
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('Выйти'),
            onPressed: () {
              context.read<AuthBloc>().add(UserLogoutEvent());
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}
