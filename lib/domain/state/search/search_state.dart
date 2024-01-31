part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchProgressState extends SearchState {}

class SearchFinishedState extends SearchState {
  final List<Song> searchResult;

  SearchFinishedState(this.searchResult);

  SearchFinishedState copyWith({List<Song>? songs}) {
    return SearchFinishedState(
      songs ?? searchResult
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