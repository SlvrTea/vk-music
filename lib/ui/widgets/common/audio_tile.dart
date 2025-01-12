import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/features/audio_bottom_sheet/audio_bottom_sheet_widget.dart';

import '../../../data/models/song/song.dart';
import '../../../domain/enum/play_status.dart';
import '../../../domain/model/player_playlist.dart';
import '../../../domain/state/music_player/music_player_cubit.dart';
import 'media_cover.dart';

class AudioTile extends StatelessWidget {
  final Song song;
  final bool withMenu;
  final int? playlistId;
  final PlayerPlaylist playlist;

  const AudioTile({
    super.key,
    required this.song,
    required this.playlist,
    this.withMenu = false,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    final musicBloc = context.watch<MusicPlayerCubit>();
    final duration = song.duration;
    final formatDuration = '${duration ~/ 60}:${duration % 60 < 10 ? '0${duration % 60}' : duration % 60}';
    return ListTile(
      trailing: withMenu
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatDuration, style: context.global.theme.b1),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      backgroundColor: context.global.theme.colors.secondaryBackground,
                      builder: (_) => AudioBottomSheetWidget(
                        audio: song,
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                  color: context.global.theme.colors.mainTextColor,
                )
              ],
            )
          : Text(formatDuration),
      leading: CoverWidget(
        photoUrl: song.album?.thumb.photo270,
        child: musicBloc.state.song == song
            ? musicBloc.state.playStatus != PlayStatus.trackInPause
                ? Icon(
                    Icons.pause_rounded,
                    size: 40,
                    color: context.global.theme.colors.mainTextColor,
                  )
                : Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: context.global.theme.colors.mainTextColor,
                  )
            : null,
      ),
      titleTextStyle: context.global.theme.b3,
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        song.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.global.theme.b1,
      ),
      onTap: () => musicBloc.play(playlist: playlist, song: song),
    );
  }
}
