import 'package:flutter/material.dart';
import 'package:elementary/elementary.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_model.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_widget.dart';

abstract interface class ICachedPlaylistWidgetModel implements IWidgetModel {}

CachedPlaylistWidgetModel defaultCachedPlaylistWidgetModelFactory(
  BuildContext context,
) {
  return CachedPlaylistWidgetModel(CachedPlaylistModel());
}

class CachedPlaylistWidgetModel
    extends WidgetModel<CachedPlaylistWidget, ICachedPlaylistModel>
    implements ICachedPlaylistWidgetModel {
  CachedPlaylistWidgetModel(super.model);
}
