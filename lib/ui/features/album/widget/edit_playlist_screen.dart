import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/playlist/playlist.dart';
import '../../../widgets/common/media_cover.dart';
import 'edit_playlist_wm.dart';

@RoutePage()
class EditPlaylistScreen extends ElementaryWidget<IEditPlaylistWidgetModel> {
  const EditPlaylistScreen({
    super.key,
    required this.playlist,
  }) : super(defaultEditPlaylistWidgetModelFactory);

  final Playlist playlist;

  @override
  Widget build(IEditPlaylistWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Плейлист'),
        leading: IconButton(
          onPressed: wm.navigateBack,
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          IconButton(
            onPressed: wm.saveChanges,
            icon: const Icon(Icons.check_rounded),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: CoverWidget(photoUrl: playlist.photo!.photo300!, size: 80),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Название'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: wm.titleController,
                            decoration: const InputDecoration(isDense: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 4),
                child: Text('Описание'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: wm.descriptionController,
                  maxLines: 4,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
