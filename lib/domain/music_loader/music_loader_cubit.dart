import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/vk_api/vk_music.dart';

part 'music_loader_state.dart';

class MusicLoaderCubit extends Cubit<MusicLoaderState> {
  MusicLoaderCubit(this.vkApi) : super(MusicLoaderInitial());

  final VKApi vkApi;

  void loadMusic() {
    emit(MusicLoadingState());
    vkApi.music.getMusic(args: 'count=2000').then((value) {
      try {
        final List<Song> songs = value;
        if (songs.isNotEmpty) {
          emit(MusicLoadedState(songs: songs));
        }
      } catch (e) {
        emit(MusicLoadingFailed(errorMessage: value));
      }
    });
  }
}
