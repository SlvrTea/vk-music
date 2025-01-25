import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';

import '../../../../../domain/model/player_audio.dart';
import 'all_songs_model.dart';
import 'all_songs_screen.dart';

abstract interface class IAllSongsWidgetModel implements IWidgetModel {
  EntityValueListenable<List<PlayerAudio>> get audios;

  Future<void> loadMore();
}

AllSongsWidgetModel defaultAllSongsWidgetModelFactory(BuildContext context) =>
    AllSongsWidgetModel(AllSongsModel(context.global.audioRepository));

class AllSongsWidgetModel extends WidgetModel<AllArtistSongsScreen, IAllSongsModel> implements IAllSongsWidgetModel {
  AllSongsWidgetModel(super.model);

  final _audiosEntity = EntityStateNotifier<List<PlayerAudio>>();

  @override
  EntityValueListenable<List<PlayerAudio>> get audios => _audiosEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(widget.initialAudios);
    super.initWidgetModel();
  }

  @override
  Future<void> loadMore() async {
    final audioList = [..._audiosEntity.value.data!];
    final res = await model.search(
      artistId: widget.artistId,
      count: 30 + audioList.length,
      offset: audioList.length,
    );
    _audiosEntity.content([...audioList, ...res.items]);
  }
}
