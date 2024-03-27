part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchProgressState extends SearchState {}

class SearchFinishedState extends SearchState {
  final String query;
  final List<Song> searchResult;
  final List<Playlist>? playlistsResult;
  final List<Playlist>? albumResult;

  SearchFinishedState({
    required this.query,
    required this.searchResult,
    this.playlistsResult,
    this.albumResult
  });

  SearchFinishedState copyWith(
      {String? query, List<Song>? searchResult, List<Playlist>? playlistsResult, List<Playlist>? albumResult}) {
    return SearchFinishedState(
      query: query ?? this.query,
      searchResult: searchResult ?? this.searchResult,
      playlistsResult: playlistsResult ?? this.playlistsResult,
      albumResult: albumResult ?? this.albumResult
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