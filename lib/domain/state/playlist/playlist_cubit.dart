import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/user.dart';
import '../../../data/vk_api/models/vk_api.dart';
import '../../models/playlist.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final VKApi vkApi;
  final Box userBox = Hive.box('userBox');

  PlaylistCubit(this.vkApi) : super(PlaylistInitial());

  void loadPlaylist(Playlist playlist) {
    emit(PlaylistLoadingState());
    vkApi.music.getMusic(args: 'album_id=${playlist.id}&count=2000').then((value) {
      try {
        final List<Song> songs = value;
        emit(PlaylistLoadedState(songs: songs, playlist: playlist));
      } catch (e) {
        emit(PlaylistLoadingErrorState(value));
      }
    });
  }

  void deleteFromPlaylist(
      {required Playlist playlist, required List<Song> songsToDelete, required List<Song> allPlaylistSongs}) {
    final User user = userBox.get('user');
    allPlaylistSongs.removeWhere((element) => songsToDelete.contains(element));
    final audios = songsToDelete.map((e) => e.id).toList().join(',');
    log('From playlist ${playlist.title} deleted audios with following ids: $audios');
    emit((state as PlaylistLoadedState).copyWith(songs: allPlaylistSongs));
    try {
      vkApi.music.method('audio.removeFromPlaylist', 'playlist_id=${playlist.id}&owner_id=${user.userId}&audio_ids=$audios');
    } catch (e) {
      emit(PlaylistLoadingErrorState(e.toString()));
    }
  }

  void savePlaylist(
      {required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder}) async {
    final User user = userBox.get('user');
    String reorderFormat = '';
    if (reorder != null && reorder.isNotEmpty) {
      reorderFormat += '[';
      for (List element in reorder) {
        if (element != reorder.last) {
          reorderFormat += '[${element.join(',')}],';
        } else {
          reorderFormat += '[${element.join(',')}]';
        }
      }
      reorderFormat += ']';
      log(reorderFormat);
    }
    var response = await vkApi.music.method('execute.savePlaylist',
      'owner_id=${user.userId}'
      '&playlist_id=${playlist.id}'
      '&title=${title ?? playlist.title}'
      '&description=${description ?? playlist.description}'
      '${songsToAdd == null ? '' : '&audio_ids_to_add=${songsToAdd.map((e) => e.id).toList().join(',')}'}'
      '${reorder == null ? '' : '&reorder_actions=$reorderFormat'}'
    );
    log(response.data.toString());
    emit((state as PlaylistLoadedState).copyWith(playlist: Playlist.fromMap(map: response.data['response']['playlist'])));
  }
}
