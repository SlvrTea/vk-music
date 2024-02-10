
import 'package:vk_music/data/api/api_song.dart';
import 'package:vk_music/domain/models/song.dart';

class SongMapper {
  static Song fromApi(ApiSong song) {
    return Song(
      artist: song.artist,
      title: song.title,
      duration: song.duration,
      accessKey: song.accessKey,
      id: song.id,
      shortId: song.shortId,
      ownerId: song.ownerId,
      url: song.url,
      photoUrl68: song.photoUrl68,
      photoUrl135: song.photoUrl135,
      photoUrl600: song.photoUrl600
    );
  }
}