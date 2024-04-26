
part of 'search_cubit.dart';

final class SearchState {
  final String? query;
  final List<Song>? songs;
  final List<Playlist>? playlists;
  final List<Playlist>? albums;

  const SearchState({
    this.query,
    this.songs,
    this.playlists,
    this.albums,
  });


  SearchState copyWith({
    final String? query,
    final List<Song>? songs,
    final List<Playlist>? playlists,
    final List<Playlist>? albums,
  }) {
    return SearchState(
      query: query ?? this.query,
      songs: songs ?? this.songs,
      playlists: playlists ?? this.playlists,
      albums: albums ?? this.albums,
    );
  }
}