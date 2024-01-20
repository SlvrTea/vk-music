part of 'playlists_cubit.dart';

@immutable
abstract class PlaylistsState {}

class PlaylistsInitial extends PlaylistsState {}

class PlaylistsLoadedState extends PlaylistsState {
  final List<Playlist> playlists;

  PlaylistsLoadedState(this.playlists);
}
