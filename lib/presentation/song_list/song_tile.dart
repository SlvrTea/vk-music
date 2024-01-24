
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/data/vk_api/models/song.dart';

import '../../domain/state/music_player/music_player_bloc.dart';
import '../cover.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final PlayerMode playerMode;
  final int index;

  const SongTile({super.key, required this.song, required this.playerMode, required this.index});

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerBloc>();
    int duration = int.parse(song.duration);
    return ListTile(
      trailing: Text('${duration ~/ 60}:${duration % 60 == 0 ? '00' : duration % 60}'),
      leading: CoverWidget(
          photoUrl: song.photoUrl135,
          child: musicBloc.state.song == song
              ? musicBloc.state.playStatus == PlayStatus.trackPlaying
              ? const Icon(Icons.pause_rounded, size: 40)
              : const Icon(Icons.play_arrow_rounded, size: 40)
              : null
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => musicBloc.add(PlayMusicEvent(song: song, index: index))
    );
  }
}

class _Icon extends StatefulWidget {
  const _Icon({super.key});

  @override
  State<_Icon> createState() => _IconState();
}

class _IconState extends State<_Icon> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(curve: Curves.easeInOutCubic, parent: _controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.playStatus == PlayStatus.trackPlaying) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.song != null &&
                state.processingState != ProcessingState.idle) {
              context
                  .read<MusicPlayerBloc>()
                  .add(PlayMusicEvent(index: 0, song: state.song!.copyWith()));
            }
          },
          child: AnimatedIcon(
            progress: _animation,
            icon: AnimatedIcons.play_pause,
            size: 24,
          ),
        );
      },
    );
  }
}
