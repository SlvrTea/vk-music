import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/core/presentation/cover.dart';

import '../../../../core/domain/const.dart';
import '../../../../core/domain/models/playlist.dart';
import '../../../../core/domain/models/song.dart';
import '../../domain/state/playlist_cubit.dart';

class SelectPlaylist extends StatelessWidget {
  const SelectPlaylist(this.song, this.ownedPlaylists, {super.key});

  final Song song;
  final List<Playlist> ownedPlaylists;

  @override
  Widget build(BuildContext context) {
    final playlistCubit = PlaylistCubit();
    return BlocProvider(
      create: (_) => playlistCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Мои плейлисты'),),
        body: Center(
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 120 / 155,
              children: ownedPlaylists.map((e) {
                return SizedBox(
                  height: 200,
                  width: 150,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      playlistCubit.addAudiosToPlaylist(e, [song]);
                      navigatorKey.currentState!.pop();
                      final snackBar = SnackBar(
                        content: Text(
                            'Аудиозапись добавлена в плейлист ${e.title}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
