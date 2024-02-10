import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/domain/models/playlist.dart';
import 'package:vk_music/internal/dependencies/repository_module.dart';

part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistsCubit() : super(PlaylistsInitial());
  
  final musicRepository = RepositoryModule.musicRepository();
  
  Future<void> getPlaylists() async => emit(PlaylistsLoadedState(await musicRepository.getPlaylists('count=200')));
}
