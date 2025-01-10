import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/domain/state/music_player/music_player_cubit.dart';
import '../../../../core/presentation/navbar/navigation_bar.dart';

import '../../../core/domain/models/playlist.dart';

class PlaylistTab extends StatelessWidget {
  const PlaylistTab(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>(); // Add this

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              title: const Text('Плейлист'),
              backgroundColor: Colors.black.withAlpha(179),
            ),
          ),
        ),
      ),
      body: PlaylistTabBody(playlist),
      bottomNavigationBar:
          musicBloc.state.processingState != ProcessingState.idle // Add this
              ? const NavBar(
                  items: [] // Empty items since we don't need navigation here
                  )
              : null,
    );
  }
}
