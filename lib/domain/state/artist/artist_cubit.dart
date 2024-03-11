import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    final songs = await musicRepository.getAudiosByArtist(artist);
    emit(ArtistState(artist: artist, artistAlbums: albums, artistSongs: songs));
  }
}
