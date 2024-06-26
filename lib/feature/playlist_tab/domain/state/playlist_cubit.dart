
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/domain/models/playlist.dart';
import '../../../../core/domain/models/song.dart';
import '../../../../core/internal/dependencies/repository_module.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final musicRepository = RepositoryModule.musicRepository();

  PlaylistCubit() : super(PlaylistInitial());

  void loadPlaylist(Playlist playlist) async {
    emit(PlaylistLoadingState());
    final playlistSongs = await musicRepository.getPlaylistAudios(playlist);
    emit(PlaylistLoadedState(songs: playlistSongs, playlist: playlist));
  }

  void deleteFromPlaylist(
      {required Playlist playlist, required List<Song> songsToDelete}) {
    assert (state is PlaylistLoadedState);
    final songs = (state as PlaylistLoadedState).songs;
    songs.removeWhere((element) => songsToDelete.contains(element));
    musicRepository.deleteFromPlaylist(playlist: playlist, songsToDelete: songsToDelete);
    emit((state as PlaylistLoadedState).copyWith(songs: songs));
  }

  void savePlaylist(
      {required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder}) async {
    final response =
      await musicRepository.savePlaylist(playlist: playlist, title: title, description: description, songsToAdd: songsToAdd, reorder: reorder);
    emit((state as PlaylistLoadedState).copyWith(playlist: response));
  }

  void addAudiosToPlaylist(Playlist playlist, List<Song> audiosToAdd) async {
    final response = await musicRepository.addAudiosToPlaylist(playlist, audiosToAdd);
    emit((state as PlaylistLoadedState).copyWith(playlist: response));
  }
}
