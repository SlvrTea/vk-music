
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/presentation/cover.dart';

import '../../data/vk_api/models/song.dart';
import '../../domain/const.dart';
import '../../domain/state/playlist/playlist_cubit.dart';
import '../../domain/state/playlists/playlists_cubit.dart';

class SelectPlaylist extends StatelessWidget {
  const SelectPlaylist(this.song, {super.key});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaylistsCubit>();
    final state = cubit.state;
    final playlistCubit = context.read<PlaylistCubit>();
    if (state is PlaylistsLoadedState) {
      return Scaffold(
        appBar: AppBar(title: const Text('Мои плейлисты'),),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 120/155,
              children: state.playlists.map((e) {
                if (e.isOwner) {
                  return SizedBox(
                    height: 200,
                    width: 150,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        playlistCubit.addAudiosToPlaylist(e, [song.id!]);
                        navigatorKey.currentState!.pop();
                      },
                      child: Column(
                        children: [
                          CoverWidget(photoUrl: e.photoUrl600,
                              borderRadius: BorderRadius.circular(16),
                              size: 115),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(e.title, style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }).toList(),
            ),
          ),
        ),
      );
    }
    cubit.getPlaylists();
    return const Center(child: CircularProgressIndicator());
  }
}
