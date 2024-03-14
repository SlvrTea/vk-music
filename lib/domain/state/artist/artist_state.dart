part of 'artist_cubit.dart';

class ArtistState {
  final Artist? artist;
  final List<Playlist>? artistAlbums;
  final List<Playlist>? artistPlaylists;
  final List<Song>? artistSongs;

  ArtistState({this.artist, this.artistAlbums, this.artistSongs, this.artistPlaylists});

  ArtistState copyWith({
    final Artist? artist,
    final List<Playlist>? artistAlbums,
    final List<Playlist>? artistPlaylists,
    final List<Song>? artistSongs,
  }) {
    return ArtistState(
      artist: artist ?? this.artist,
      artistAlbums: artistAlbums ?? this.artistAlbums,
      artistPlaylists: artistPlaylists ?? this.artistPlaylists,
      artistSongs: artistSongs ?? this.artistSongs,
    );
  }
}