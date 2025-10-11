import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/ui/features/album/widget/album_more_sheet.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_model.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_widget.dart';

abstract interface class ICachedPlaylistWidgetModel implements IWidgetModel {
  Future<void> onMoreTap();
}

CachedPlaylistWidgetModel defaultCachedPlaylistWidgetModelFactory(
  BuildContext context,
) {
  return CachedPlaylistWidgetModel(CachedPlaylistModel());
}

class CachedPlaylistWidgetModel
    extends WidgetModel<CachedPlaylistWidget, ICachedPlaylistModel>
    implements ICachedPlaylistWidgetModel {
  CachedPlaylistWidgetModel(super.model);

  @override
  Future<void> onMoreTap() async {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context.findRootAncestorStateOfType<NavigatorState>()!.context,
      builder: (context) => AlbumMoreSheet(
        onEditTap: () async {
          // context.maybePop();
          // await onEditPlaylistTap();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'В данной версии редактирование кешированных плейлистов недоступно',
              ),
            ),
          );
        },
        onDeleteTap: () async {
          context
            ..maybePop()
            ..maybePop();
          context.global.audioRepository.deleteCachedPlaylist(widget.playlist);
        },
      ),
    );
  }
}
