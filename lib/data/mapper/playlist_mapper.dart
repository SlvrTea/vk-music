
import 'package:vk_music/data/api/api_playlist.dart';
import 'package:vk_music/domain/models/playlist.dart';

class PlaylistMapper {
  static Playlist formApi(ApiPlaylist playlist) {
    return Playlist(
      title: playlist.title,
      description: playlist.description,
      id: playlist.id,
      isOwner: playlist.isOwner!,
      isFollowing: playlist.isFollowing!,
      ownerId: playlist.ownerId,
      accessKey: playlist.accessKey,
      photoUrl34: playlist.photoUrl34,
      photoUrl68: playlist.photoUrl68,
      photoUrl135: playlist.photoUrl135,
      photoUrl270: playlist.photoUrl270,
      photoUrl300: playlist.photoUrl300,
      photoUrl600: playlist.photoUrl600
    );
  }
}