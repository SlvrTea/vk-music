import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/ui/features/cache/cached_playlist/cached_playlist_wm.dart';

@RoutePage()
class CachedPlaylistWidget
    extends ElementaryWidget<ICachedPlaylistWidgetModel> {
  const CachedPlaylistWidget({super.key})
    : super(defaultCachedPlaylistWidgetModelFactory);

  @override
  Widget build(ICachedPlaylistWidgetModel wm) {
    return Container();
  }
}
