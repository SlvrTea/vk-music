import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/data/vk_api/models/user.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/vk_api.dart';
import '../../models/playlist.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final VKApi vkApi;
  SearchCubit(this.vkApi) : super(SearchInitial());

  void search(String q, {int? count, int? offset}) async {
    emit(SearchProgressState());
    final responseAudio = await vkApi.music.method('audio.search',
        'q=$q'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    final songs = (responseAudio.data['response']['items'] as List)
        .map((e) => Song.fromMap(map: e))
        .toList();
    final responseAlbums = await vkApi.music.method('audio.searchAlbums',
        'q=$q'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    final albums = (responseAlbums.data['response']['items'] as List)
        .map((e) => Playlist.fromMap(map: e))
        .toList();
    emit(SearchFinishedState(songs, albums));
  }

  void loadMore(String q, {int? offset}) async {
    final response = await vkApi.music.method('audio.search',
        'q=$q'
        '&count=20'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    final songs = (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(map: e))
        .toList();
    emit((state as SearchFinishedState).copyWith(songs: songs));
  }

  void getRecommendations({int? offset}) async {
    final User user = Hive.box('userBox').get('user');
    final response = await vkApi.music.method('audio.getRecommendations',
        'user_id=${user.userId}&count=20${offset == null ? '' : '&offset=$offset'}'
    );
    final songs = (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(map: e))
        .toList();
    if (offset != null) {
      (state as SearchRecommendations).recs.addAll(songs);
      emit(SearchRecommendations((state as SearchRecommendations).recs));
    } else {
      emit(SearchRecommendations(songs));
    }
  }
}
