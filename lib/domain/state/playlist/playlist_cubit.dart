import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/vk_api.dart';
import '../../models/playlist.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final VKApi vkApi;
  PlaylistCubit(this.vkApi) : super(PlaylistInitial());

  void loadPlaylist(Playlist playlist) {
    emit(PlaylistLoadingState());
    vkApi.music.getMusic(args: 'album_id=${playlist.id}&count=2000').then((value) {
      try {
        final List<Song> songs = value;
        if (songs.isNotEmpty) {
          emit(PlaylistLoadedState(songs: songs, playlist: playlist));
        }
      } catch (e) {
        emit(PlaylistLoadingErrorState(value));
      }
    });
  }
}
