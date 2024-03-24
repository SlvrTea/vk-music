
import '../models/song.dart';

abstract class ISongsList {
  final List<Song>? songs;

  ISongsList(this.songs);
}