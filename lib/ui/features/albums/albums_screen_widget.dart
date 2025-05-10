import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/widgets/common/playlist_widget.dart';

import 'albums_screen_wm.dart';

@RoutePage()
class AlbumsScreen extends ElementaryWidget<IAlbumsScreenWidgetModel> {
  const AlbumsScreen({super.key}) : super(defaultAlbumsScreenWidgetModelFactory);

  @override
  Widget build(IAlbumsScreenWidgetModel wm) {
    return Scaffold(
      body: EntityStateNotifierBuilder(
        listenableEntityState: wm.playlists,
        loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
        builder: (context, playlists) {
          return GridView.count(
            padding: EdgeInsets.only(top: wm.mediaQuery.padding.top + 8),
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 120 / 155,
            children: [
              ...?playlists?.map((e) => PlaylistWidget(playlist: e)),
              SizedBox(height: wm.mediaQuery.padding.bottom)
            ],
          );
        },
      ),
    );
  }
}
