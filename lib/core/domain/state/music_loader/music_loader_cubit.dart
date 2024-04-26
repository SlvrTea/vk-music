
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../internal/dependencies/repository_module.dart';
import '../../models/song.dart';
import '../../repository/music_repository.dart';

part 'music_loader_state.dart';

class MusicLoaderCubit extends Cubit<MusicLoaderState> {
  late final MusicRepository musicRepository;

  MusicLoaderCubit() : super(MusicLoaderInitial()) {
    musicRepository = RepositoryModule.musicRepository();
  }

  void loadMusic() async {
    emit(MusicLoadingState());
    var response = await musicRepository.getCurrentUserAudios();
    try {
      final List<Song> songs = response;
      if (songs.isNotEmpty) {
        emit(MusicLoadedState(songs: songs));
      }
    } catch (e) {
      emit(MusicLoadingFailed(errorMessage: response.toString()));
    }
  }

  void audioDelete(Song song) {
    musicRepository.deleteAudio(song);
    (state as MusicLoadedState).songs.remove(song);
    emit(MusicLoadedState(songs: (state as MusicLoadedState).songs));
  }

  void addAudio(Song audio) {
    musicRepository.addAudio(audio);
    (state as MusicLoadedState).songs.add(audio);
    emit(MusicLoadedState(songs: (state as MusicLoadedState).songs));
  }
  
  void reorder(Song song, {String? before, String? after}) =>
      musicRepository.reorder(song, before: before, after: after);
}
