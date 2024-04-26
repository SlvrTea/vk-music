import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/domain/models/playlist.dart';
import '../../../../core/domain/models/song.dart';
import '../../../../core/domain/repository/music_repository.dart';
import '../../../../core/internal/dependencies/repository_module.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MusicRepository musicRepository = RepositoryModule.musicRepository();
  SearchCubit() : super(const SearchState()) {
    getRecommendations();
  }

  void search(String q, {int count = 50, int? offset}) async {
    final songs = await musicRepository.search(q, count: count, offset: offset);
    final albums = await musicRepository.searchAlbum(q);
    final playlists = await musicRepository.searchPlaylist(q);
    emit(SearchState(query: q, songs: songs, albums: albums, playlists: playlists));
  }

  void loadMore(String q, {int count = 30, int? offset}) async {
    final songs = await musicRepository.search(q, offset: offset, count: count);
    state.songs?.addAll(songs);
    emit(state.copyWith(query: q, songs: state.songs));
  }

  void getRecommendations({int? offset}) async {
    final songs = await musicRepository.getRecommendations(offset: offset) as List<Song>;
    if (offset != null) {
      state.songs?.addAll(songs);
      emit(SearchState(songs: songs));
      return;
    }
    emit(SearchState(songs: songs));
  }
}
