import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/domain/model/player_audio.dart';
import 'package:vk_music/ui/widgets/common/media_cover.dart';

import '../../../../data/models/playlist/playlist.dart';

@RoutePage()
class SelectPlaylistWidget extends StatelessWidget {
  const SelectPlaylistWidget({
    super.key,
    required this.song,
    required this.ownedPlaylists,
    required this.addToPlaylist,
  });

  final PlayerAudio song;
  final List<Playlist> ownedPlaylists;
  final void Function(Playlist song, PlayerAudio audio) addToPlaylist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои плейлисты'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 120 / 155,
            children: ownedPlaylists.map((e) {
              return GestureDetector(
                onTap: () {
                  addToPlaylist(e, song);
                  context.router.maybePop();
                },
                child: SizedBox(
                  height: 200,
                  width: 150,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CoverWidget(
                          photoUrl: e.thumbs?.first.photo1200,
                          size: 115,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            e.title,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
