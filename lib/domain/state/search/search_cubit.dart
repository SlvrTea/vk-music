import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/data/vk_api/models/user.dart';

import '../../../data/vk_api/models/song.dart';
import '../../../data/vk_api/models/vk_api.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final VKApi vkApi;
  SearchCubit(this.vkApi) : super(SearchInitial());

  void search(String q, {int? count, int? offset}) async {
    emit(SearchProgressState());
    final response = await vkApi.music.method('audio.search',
        'q=$q'
        '${count != null ? '&count=$count' : ''}'
        '${offset != null ? '&offset=$offset' : ''}'
    );
    final songs = (response.data['response']['items'] as List)
        .map((e) => Song.fromMap(map: e))
        .toList();
    emit(SearchFinishedState(songs));
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
    (state as SearchFinishedState).searchResult.addAll(songs);
    emit(SearchFinishedState((state as SearchFinishedState).searchResult));
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
