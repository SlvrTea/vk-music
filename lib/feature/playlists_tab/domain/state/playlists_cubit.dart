import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/domain/models/playlist.dart';
import '../../../../core/domain/repository/music_repository.dart';
import '../../../../core/internal/dependencies/repository_module.dart';

part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  late final MusicRepository musicRepository;
  PlaylistsCubit() : super(PlaylistsInitial()) {
    musicRepository = RepositoryModule.musicRepository();
  }
  
  Future<void> getPlaylists() async => emit(PlaylistsLoadedState(await musicRepository.getPlaylists()));

  void followPlaylist(Playlist playlist) {
    musicRepository.followPlaylist(playlist);
    final playlists = (state as PlaylistsLoadedState).playlists;
    playlists.add(playlist);
    emit(PlaylistsLoadedState(playlists));
  }

  void deletePlaylist(Playlist playlist) {
    musicRepository.deletePlaylist(playlist);
    final playlists = (state as PlaylistsLoadedState).playlists;
    playlists.remove(playlist);
    emit(PlaylistsLoadedState(playlists));
  }
}
