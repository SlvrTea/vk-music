part of 'artist_cubit.dart';

class ArtistState {
  final Artist? artist;
  final List<Playlist>? artistAlbums;
  final List<Song>? artistSongs;

  ArtistState({this.artist, this.artistAlbums, this.artistSongs});
}