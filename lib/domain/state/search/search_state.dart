part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchProgressState extends SearchState {}

class SearchFinishedState extends SearchState {
  final List<Song> searchResult;
  final List<Playlist> playlistsResult;

  SearchFinishedState(this.searchResult, this.playlistsResult);

  SearchFinishedState copyWith({List<Song>? songs, List<Playlist>? playlists}) {
    return SearchFinishedState(
      songs ?? searchResult,
      playlists ?? playlistsResult
    );
  }
}

class SearchRecommendations extends SearchState {
  final List<Song> recs;

  SearchRecommendations(this.recs);

  SearchRecommendations copyWith({List<Song>? recs}) {
    return SearchRecommendations(
      recs ?? this.recs
    );
  }
}