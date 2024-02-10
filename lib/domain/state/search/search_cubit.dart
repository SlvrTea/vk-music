import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/internal/dependencies/repository_module.dart';

import '../../models/playlist.dart';
import '../../models/song.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final musicRepository = RepositoryModule.musicRepository();
  SearchCubit() : super(SearchInitial());

  void search(String q, {int? count, int? offset}) async {
    // emit(SearchProgressState());
    // final responseAudio = await musicRepository.music.method('audio.search',
    //     'q=$q'
    //     '${count != null ? '&count=$count' : ''}'
    //     '${offset != null ? '&offset=$offset' : ''}'
    // );
    // final songs = (responseAudio.data['response']['items'] as List)
    //     .map((e) => Song.fromMap(map: e))
    //     .toList();
    // final responseAlbums = await musicRepository.music.method('audio.searchAlbums',
    //     'q=$q'
    //     '${count != null ? '&count=$count' : ''}'
    //     '${offset != null ? '&offset=$offset' : ''}'
    // );
    // final albums = (responseAlbums.data['response']['items'] as List)
    //     .map((e) => Playlist.fromMap(map: e))
    //     .toList();
    // emit(SearchFinishedState(songs, albums));
  }

  void loadMore(String q, {int? offset}) async {
    // final response = await musicRepository.music.method('audio.search',
    //     'q=$q'
    //     '&count=20'
    //     '${offset != null ? '&offset=$offset' : ''}'
    // );
    // final songs = (response.data['response']['items'] as List)
    //     .map((e) => Song.fromMap(map: e))
    //     .toList();
    // (state as SearchFinishedState).searchResult.addAll(songs);
    // emit((state as SearchFinishedState).copyWith(songs: (state as SearchFinishedState).searchResult));
  }

  void getRecommendations({int? offset}) async {
    // emit(SearchProgressState());
    // final User user = Hive.box('userBox').get('user');
    // final response = await musicRepository.music.method('audio.getRecommendations',
    //     'user_id=${user.userId}&count=20${offset == null ? '' : '&offset=$offset'}'
    // );
    // final songs = (response.data['response']['items'] as List)
    //     .map((e) => Song.fromMap(map: e))
    //     .toList();
    // if (offset != null) {
    //   (state as SearchRecommendations).recs.addAll(songs);
    //   emit(SearchRecommendations((state as SearchRecommendations).recs));
    // } else {
    //   emit(SearchRecommendations(songs));
    // }
  }
}
