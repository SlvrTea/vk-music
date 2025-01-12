import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/song/song.dart';

import 'all_songs_model.dart';
import 'all_songs_screen.dart';

abstract interface class IAllSongsWidgetModel implements IWidgetModel {
  EntityValueListenable<List<Song>> get audios;

  Future<void> loadMore();
}

AllSongsWidgetModel defaultAllSongsWidgetModelFactory(BuildContext context) =>
    AllSongsWidgetModel(AllSongsModel(context.global.audioRepository));

class AllSongsWidgetModel extends WidgetModel<AllSongsScreen, IAllSongsModel> implements IAllSongsWidgetModel {
  AllSongsWidgetModel(super.model);

  final _audiosEntity = EntityStateNotifier<List<Song>>();

  @override
  EntityValueListenable<List<Song>> get audios => _audiosEntity;

  @override
  void initWidgetModel() {
    _audiosEntity.content(widget.initialAudios);
    super.initWidgetModel();
  }

  @override
  Future<void> loadMore() async {
    final audioList = [..._audiosEntity.value.data!];
    final res = await model.search(
      q: widget.query,
      count: 30 + audioList.length,
      offset: audioList.length,
    );
    _audiosEntity.content([...audioList, ...res.items]);
  }
}
