import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vk_music/domain/repository/music_repository.dart';
import 'package:vk_music/internal/dependencies/repository_module.dart';

import '../../models/playlist.dart';
import '../../models/song.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  late final MusicRepository musicRepository;
  SearchCubit() : super(SearchInitial()) {
    musicRepository = RepositoryModule.musicRepository();
  }

  void search(String q, {int count = 50, int? offset}) async {
    emit(SearchProgressState());
    final songs = await musicRepository.search(q, count: count, offset: offset);
    final albums = await musicRepository.searchAlbum(q);
    final playlists = await musicRepository.searchPlaylist(q);
    emit(SearchFinishedState(searchResult: songs, albumResult: albums, playlistsResult: playlists));
  }

  void loadMore(String q, {int? offset}) async {
    final songs = await musicRepository.search(q, offset: offset);
    (state as SearchFinishedState).searchResult.addAll(songs);
    emit((state as SearchFinishedState).copyWith(searchResult: (state as SearchFinishedState).searchResult));
  }

  void getRecommendations({int? offset}) async {
    emit(SearchProgressState());
    final songs = await musicRepository.getRecommendations(offset: offset) as List<Song>;
    if (offset != null) {
      (state as SearchRecommendations).recs.addAll(songs);
      emit(SearchRecommendations((state as SearchRecommendations).recs));
    } else {
      emit(SearchRecommendations(songs));
    }
  }
}
