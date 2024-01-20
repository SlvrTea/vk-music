
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/playlists_tab/playlists_tab.dart';
import 'package:vk_music/presentation/song_list/music_list.dart';
import 'package:vk_music/presentation/navbar/navigation_bar.dart';

import '../../domain/music_loader/music_loader_cubit.dart';
import '../../domain/state/auth/auth_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final tabs = const [
    _MainTab(),
    Center(child: Text('2')),
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
          NavBarItem(icon: const Icon(Icons.music_note_rounded), activeColor: Colors.redAccent, inactiveColor: Colors.grey),
          NavBarItem(icon: const Icon(Icons.search), activeColor: Colors.redAccent, inactiveColor: Colors.grey),
          NavBarItem(icon: const Icon(Icons.album), activeColor: Colors.redAccent, inactiveColor: Colors.grey)
        ],
      ),
    );
  }
}

class _MainTab extends StatelessWidget {
  const _MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MusicLoaderCubit>().state;
    if (state is MusicLoadedState) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const _PlaylistsSection(),
            MusicList(songList: state.songs),
          ],
        ),
      );
    } else if (state is MusicLoadingFailed) {
      return Text(state.errorMessage);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _PlaylistsSection extends StatelessWidget with PlaylistCoverGetterMixin {
  const _PlaylistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistsCubit>();
    final state = cubit.state;
    if (state is PlaylistsLoadedState) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: getCovers(state.playlists)
        ),
      );
    }
    cubit.getPlaylists();
    return const Center(child: CircularProgressIndicator());
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

