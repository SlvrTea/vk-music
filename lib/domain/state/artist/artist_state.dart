part of 'artist_cubit.dart';

class ArtistState {
  final Artist? artist;
  final List<Playlist>? artistAlbums;
  final List<Playlist>? playlists;
  final List<Song>? songs;

  ArtistState({this.artist, this.artistAlbums, this.songs, this.playlists});

  ArtistState copyWith({
    final Artist? artist,
    final List<Playlist>? artistAlbums,
    final List<Playlist>? playlists,
    final List<Song>? songs,
  }) {
    return ArtistState(
      artist: artist ?? this.artist,
      artistAlbums: artistAlbums ?? this.artistAlbums,
      playlists: playlists ?? this.playlists,
      songs: songs ?? this.songs,
    );
  }
}