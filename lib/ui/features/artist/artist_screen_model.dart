import 'package:elementary/elementary.dart';
import 'package:logger/logger.dart';
import 'package:vk_music/data/models/artist/artist.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

import '../../../domain/model/player_audio.dart';

abstract interface class IArtistScreenModel extends ElementaryModel {
  Future<Artist> getArtist(String artistId);

  Future<List<PlayerAudio>> getAudiosByArtist(String artistId, {int? count, int? offset});

  Future<List<Playlist>> getAlbumsByArtist(String artistId, {int? count, int? offset});

  Future<List<Playlist>> getPlaylists(String artistName, {int? count, int? offset});
}

class ArtistScreenModel extends IArtistScreenModel {
  ArtistScreenModel(this._audioRepository);

  final _logger = Logger();

  final AudioRepository _audioRepository;

  @override
  Future<Artist> getArtist(String artistId) async {
    try {
      final res = await _audioRepository.getArtistById(artistId);
      return res;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<PlayerAudio>> getAudiosByArtist(String artistId, {int? count, int? offset}) async {
    try {
      final res = await _audioRepository.getAudiosByArtist(artistId: artistId, count: count, offset: offset);
      return res.items;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<Playlist>> getAlbumsByArtist(String artistId, {int? count, int? offset}) async {
    try {
      final res = await _audioRepository.getAlbumsByArtist(artistId: artistId, count: count, offset: offset);
      return res.items;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<Playlist>> getPlaylists(String artistName, {int? count, int? offset}) async {
    try {
      final res = await _audioRepository.searchPlaylists(query: artistName, count: count, offset: offset);
      return res.items;
    } on Exception catch (e) {
      _logger.e(e);
      rethrow;
    }
  }
}
