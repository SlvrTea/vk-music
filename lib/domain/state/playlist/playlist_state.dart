part of 'playlist_cubit.dart';

@immutable
abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoadingState extends PlaylistState {}

class PlaylistLoadedState extends PlaylistState {
  final Playlist playlist;
  final List<Song> songs;

  PlaylistLoadedState({required this.playlist, required this.songs});

  PlaylistLoadedState copyWith({Playlist? playlist, List<Song>? songs}) {
    return PlaylistLoadedState(
      playlist: playlist ?? this.playlist,
      songs: songs ?? this.songs
    );
  }
}

class PlaylistLoadingErrorState extends PlaylistState {
  final String error;

  PlaylistLoadingErrorState(this.error);
}