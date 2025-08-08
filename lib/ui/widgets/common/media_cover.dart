import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vk_music/ui/widgets/common/playlist_widget.dart';

import '../../../data/models/playlist/playlist.dart';

class CoverWidget extends StatelessWidget {
  const CoverWidget({
    super.key,
    this.child,
    this.photoUrl,
    this.borderRadius,
    this.width,
    this.height,
    this.size = 55,
  });

  final String? photoUrl;
  final double size;
  final double? height;
  final double? width;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final h = height ?? size;
    final w = width ?? size;
    if (photoUrl != null) {
      return SizedBox(
        height: h,
        width: w,
        child: Stack(alignment: Alignment.center, children: [
          ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              child: Image.network(photoUrl!, width: w, height: h, fit: BoxFit.cover)),
          Center(child: child)
        ]),
      );
    }
    return SizedBox(
      height: h,
      width: w,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              child: Container(color: Colors.grey.withAlpha(76))),
          Center(
            child: SvgPicture.asset(
              'assets/note.svg',
              width: w - 20,
              height: w - 20,
            ),
          ),
          Center(child: child)
        ],
      ),
    );
  }
}

mixin PlaylistCoverGetterMixin {
  List<Widget> getCovers(List<Playlist> playlists) {
    final result = <Widget>[];
    for (Playlist element in playlists) {
      result.add(PlaylistWidget(playlist: element));
    }
    return result;
  }
}
