
import '../models/playlist.dart';

abstract class IPlaylistsList {
  final List<Playlist>? playlists;

  IPlaylistsList(this.playlists);
}