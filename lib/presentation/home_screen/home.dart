
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/domain/state/nav_bar/nav_bar_cubit.dart';
import 'package:vk_music/domain/state/playlists/playlists_cubit.dart';
import 'package:vk_music/presentation/auth/login_screen.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/navbar/navigation_bar.dart';
import 'package:vk_music/presentation/playlists_tab/playlists_tab.dart';
import 'package:vk_music/presentation/search/search_tab.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/state/auth/auth_bloc.dart';
import '../../domain/state/music_loader/music_loader_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final tabs = const [
    _MainTab(),
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

class _MainTab extends StatelessWidget {
  const _MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MusicLoaderCubit>();
    final state = cubit.state;
    if (state is! MusicLoadedState) {
      return const Center(child: CircularProgressIndicator());
    }
    final playlist = PlayerPlaylist.formSongList(state.songs);
    return RefreshIndicator(
      onRefresh: () async {
        cubit.loadMusic();
        context.read<PlaylistsCubit>().getPlaylists();
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: _PlaylistsSection(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text('Моя музыка: ${state.songs.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            )
          ),
          SliverReorderableList(
            itemBuilder: (context, index) {
              return Material(
                key: ValueKey(index),
                child: ReorderableDelayedDragStartListener(
                  index: index,
                  child: SongTile(
                    song: state.songs[index],
                    withMenu: true,
                    playlist: playlist
                  )
                ),
              );
            },
            itemCount: state.songs.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              if (newIndex == 0) {
                final oldSongId = state.songs[0].shortId;
                final item = state.songs.removeAt(oldIndex);
                state.songs.insert(newIndex, item);
                cubit.reorder(item, before: oldSongId);
              } else {
                final oldSongId = state.songs[newIndex - 1].shortId;
                final item = state.songs.removeAt(oldIndex);
                state.songs.insert(newIndex, item);
                cubit.reorder(item, after: oldSongId);
              }
            }
          )
        ],
      ),
    );
    }
}

class _PlaylistsSection extends StatelessWidget with PlaylistCoverGetterMixin {
  const _PlaylistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistsCubit>();
    final state = cubit.state;
    if (state is! PlaylistsLoadedState) {
      cubit.getPlaylists();
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 146,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getCovers(state.playlists),
        ),
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

