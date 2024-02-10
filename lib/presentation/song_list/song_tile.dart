
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/domain/models/player_playlist.dart';
import 'package:vk_music/presentation/menus/audio_context_menu.dart';

import '../../domain/const.dart';
import '../../domain/models/song.dart';
import '../../domain/state/music_player/music_player_cubit.dart';
import '../cover.dart';


class SongTile extends StatelessWidget {
  final Song song;
  final bool withMenu;
  final int? playlistId;
  final PlayerPlaylist playlist;

  const SongTile({
    super.key,
    required this.song,
    required this.playlist,
    this.withMenu = false,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    int duration = int.parse(song.duration);
    return ListTile(
      trailing: withMenu
          ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}'),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return MyAudiosMenu(song);
                    }
                  );
                },
                icon: const Icon(Icons.more_vert_rounded)
              )
            ]
          )
          : Text('${duration ~/ 60}:${duration % 60 == 0 ? '00' : duration % 60}'),
      leading: CoverWidget(
          photoUrl: song.photoUrl600,
          child: musicBloc.state.song == song
              ? musicBloc.state.playStatus == PlayStatus.trackPlaying
              ? const Icon(Icons.pause_rounded, size: 40)
              : const Icon(Icons.play_arrow_rounded, size: 40)
              : null
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () => musicBloc.playMusic(playlist: playlist, song: song)
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
    return BlocConsumer<MusicPlayerCubit, MusicPlayerState>(
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
            if (state.song != null && state.processingState != ProcessingState.idle) {
              context.read<MusicPlayerCubit>().playMusic(song: state.song!);
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
