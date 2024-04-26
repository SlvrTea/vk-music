
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/feature/home_screen/presentation/widget/body.dart';

import '../../../core/domain/state/nav_bar/nav_bar_cubit.dart';
import '../../../core/presentation/navbar/navigation_bar.dart';
import '../../auth/domain/state/auth_bloc.dart';
import '../../auth/presentation/login_screen.dart';
import '../../playlists_tab/presentation/playlists_tab.dart';
import '../../search_tab/presentation/search_tab.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final tabs = const [
    HomeTabBody(),
    SearchTab(),
    PlaylistsTab()
  ];

  @override
  Widget build(BuildContext context) {
    final navBarCubit = context.watch<NavBarCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('VK Music'),
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
                MaterialPageRoute(builder: (_) => const LoginScreen())
              );
            },
          )
        ],
      ),
    );
  }
}

