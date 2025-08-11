import 'dart:ui';

import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../../../domain/model/player_audio.dart';
import '../../../widgets/common/audio_tile.dart';

class QueueTab extends StatelessWidget {
  const QueueTab({super.key, required this.playlist});

  final EntityValueListenable<List<PlayerAudio>?> playlist;

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EntityStateNotifierBuilder(
        listenableEntityState: playlist,
        builder: (context, playlist) {
          if (playlist == null) return const Center(child: Text('В очереди нет песен.'));
          final player = context.global.audioPlayer;
          return CustomScrollView(
            slivers: [
              SliverReorderableList(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(index),
                    index: index,
                    child: AudioTile(
                      audio: player.shuffleModeEnabled ? playlist[player.shuffleIndices[index]] : playlist[index],
                      playlist: playlist,
                      withMenu: true,
                    ),
                  );
                },
                onReorder: player.move,
                proxyDecorator: _proxyDecorator,
              )
            ],
          );
        },
      ),
    );
  }
}
