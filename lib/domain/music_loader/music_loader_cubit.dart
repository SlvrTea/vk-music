import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../data/vk_api/vk_music.dart';

part 'music_loader_state.dart';

class MusicLoaderCubit extends Cubit<MusicLoaderState> {
  MusicLoaderCubit(this.vkApi) : super(MusicLoaderInitial());

  final VKApi vkApi;

  void loadMusic() async {
    emit(MusicLoadingState());
    var response = await vkApi.music.getMusic(args: 'count=2000');
    log('Loading user music. API response: ${response.toString()}');
    try {
      final List<Song> songs = response;
      if (songs.isNotEmpty) {
        emit(MusicLoadedState(songs: songs));
      }
    } catch (e) {
      emit(MusicLoadingFailed(errorMessage: response));
    }
  }

  void audioDelete(Song songToDelete) {
    final User user = Hive.box('userBox').get('user');
    vkApi.music.method('audio.delete', 'owner_id=${user.userId}&audio_id=${songToDelete.shortId}');
    (state as MusicLoadedState).songs.remove(songToDelete);
    emit(MusicLoadedState(songs: (state as MusicLoadedState).songs));
    log('Deleting following audio: ${songToDelete.toString()}');
  }

  void addAudio(Song audio) {
    vkApi.music.method('audio.add', 'owner_id=${audio.ownerId}&audio_id=${audio.shortId}');
    (state as MusicLoadedState).songs.add(audio);
    emit(MusicLoadedState(songs: (state as MusicLoadedState).songs));
    log('Adding following audio: ${audio.toString()}');
  }
  
  void reorder(Song song, {String? before, String? after}) {
    assert(before != null && after != null);
    final User user = Hive.box('userBox').get('user');
    vkApi.music.method('audio.reorder',
        'owner_id=${user.userId}&audio_id=${song.shortId}'
        '${before == null ? '' : '&before=$before'}'
        '${after == null ? '' : '&after=$after'}'
    );
    log('Reorder action: ${song.toString()} now ${before ?? after}');
  }
}
