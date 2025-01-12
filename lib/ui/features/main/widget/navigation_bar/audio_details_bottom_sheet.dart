import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/ui/features/main/widget/navigation_bar/slider_bar.dart';
import 'package:vk_music/ui/widgets/common/audio_tile.dart';

import '../../../../../domain/state/music_player/music_player_cubit.dart';
import '../../../../widgets/common/media_cover.dart';
import 'audio_buttons.dart';

class AudioDetailBottomSheet extends StatelessWidget {
  const AudioDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              onPressed: () => context.maybePop(),
            ),
          )),
          DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: const TabBarView(
                  children: [_MainBody(), _MusicList()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: CoverWidget(
              photoUrl: musicBloc.state.song?.album?.thumb.photo600,
              size: MediaQuery.of(context).size.width - 50,
              borderRadius: BorderRadius.circular(16),
            )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: SliderBar(),
        ),
        const Spacer(),
        Text(musicBloc.state.song!.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, overflow: TextOverflow.ellipsis)),
        Text(musicBloc.state.song!.artist, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MusicBarPreviousAudioButton(size: 48),
            MusicBarPlayButton(size: 48),
            MusicBarNextAudioButton(size: 48)
          ],
        ),
        const Spacer(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ShuffleButton(), LoopModeButton()],
        )
      ],
    );
  }
}

class _MusicList extends StatelessWidget {
  const _MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    return ListView(
        children: musicBloc.getShuffle()
            ? musicBloc.musicPlayer.player.shuffleIndices!
                .map((e) => AudioTile(song: musicBloc.state.playlist!.songs[e], playlist: musicBloc.state.playlist!))
                .toList()
            : musicBloc.state.playlist!.songs
                .map((e) => AudioTile(song: e, playlist: musicBloc.state.playlist!))
                .toList());
  }
}
