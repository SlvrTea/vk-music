
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/domain/const.dart';
import 'package:vk_music/domain/models/music_player.dart';
import 'package:vk_music/domain/models/song.dart';
import 'package:vk_music/presentation/cover.dart';
import 'package:vk_music/presentation/navbar/audio_buttons.dart';
import 'package:vk_music/presentation/navbar/slider_bar.dart';
import 'package:vk_music/presentation/song_list/song_tile.dart';

import '../../domain/state/music_player/music_player_cubit.dart';

class AudioDetailBottomSheet extends StatefulWidget {
  const AudioDetailBottomSheet({super.key});

  @override
  State<AudioDetailBottomSheet> createState() => _AudioDetailBottomSheetState();
}

class _AudioDetailBottomSheetState extends State<AudioDetailBottomSheet> {
  Widget _body = const _MainBody();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx <= -1.5) {
          setState(() {
            _body = const _MusicList();
          });
        } else if (details.delta.dx >= 1.5) {
          setState(() {
            _body = const _MainBody();
          });
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: _body,
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              onPressed: () => navigatorKey.currentState!.pop(),
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: CoverWidget(
            photoUrl: musicBloc.state.song?.photoUrl600,
            size: MediaQuery.of(context).size.width - 50,
            borderRadius: BorderRadius.circular(16),
          )
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: SliderBar(),
        ),
        const Spacer(),
        Text(
            musicBloc.state.song!.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                overflow: TextOverflow.ellipsis)),
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
          children: [
            ShuffleButton(),
            LoopModeButton()
          ],
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
    return SafeArea(
      child: ListView(
        children: musicBloc.getShuffle()
            ? musicBloc.musicPlayer.player.shuffleIndices!.map((e) => SongTile(
                song: musicBloc.state.playlist!.songs[e],
                playlist: musicBloc.state.playlist!)).toList()
            : musicBloc.state.playlist!.songs.map((e) => SongTile(
                song: e,
                playlist: musicBloc.state.playlist!)).toList()
      ),
    );
  }
}

