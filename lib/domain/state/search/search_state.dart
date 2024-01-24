part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchProgressState extends SearchState {}

class SearchFinishedState extends SearchState {
  final List<Song> searchResult;

  SearchFinishedState(this.searchResult);
}