import 'package:bloc/bloc.dart';
import 'package:vk_music/internal/dependencies/repository_module.dart';

import '../../models/artist.dart';
import '../../models/playlist.dart';
import '../../models/song.dart';

part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final musicRepository = RepositoryModule.musicRepository();
  ArtistCubit() : super(ArtistState());

  void getArtist(String id) async {
    final artist = await musicRepository.getArtist(id);
    final albums = await musicRepository.getAlbumsByArtist(artist);
    final playlists = await musicRepository.searchPlaylist(artist.name);
    final songs = await musicRepository.getAudiosByArtist(artist, count: 30);
    emit(ArtistState(artist: artist, artistAlbums: albums, songs: songs, playlists: playlists));
  }

  void loadMoreSongs(int offset) async {
    assert(state.artist != null);
    final songs = await musicRepository.getAudiosByArtist(state.artist!, count: 20, offset: offset);
    state.songs!.addAll(songs);
    emit(state.copyWith(songs: state.songs));
  }
}
