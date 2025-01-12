import 'package:elementary/elementary.dart';
import 'package:vk_music/data/models/response/search/search_albums_response/search_albums_response.dart';
import 'package:vk_music/data/models/response/search/search_playlists_response/search_playlists_response.dart';
import 'package:vk_music/data/models/response/search/search_response/search_response.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

import '../../../data/models/response/search/search_artists_response/search_artists_response.dart';
import '../../../data/models/song/song.dart';

abstract interface class ISearchScreenModel extends ElementaryModel {
  Future<List<Song>> getRecommendations({int? count, int? offset});

  Future<SearchResponse> search({required String query});

  Future<SearchPlaylistsResponse> searchPlaylists({required String query});

  Future<SearchAlbumsResponse> searchAlbums({required String query});

  Future<SearchArtistsResponse> searchArtists({required String query});
}

class SearchScreenModel extends ISearchScreenModel {
  SearchScreenModel(
    this._audioRepository,
  );

  final AudioRepository _audioRepository;

  @override
  Future<List<Song>> getRecommendations({int? count, int? offset}) async {
    try {
      final res = await _audioRepository.getRecommendations(offset: offset, count: count);
      return res.items;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SearchResponse> search({required String query}) async {
    try {
      final res = await _audioRepository.search(query: query);
      return res;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SearchPlaylistsResponse> searchPlaylists({required String query}) async {
    try {
      final res = await _audioRepository.searchPlaylists(query: query);
      return res;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SearchAlbumsResponse> searchAlbums({required String query}) async {
    try {
      final res = await _audioRepository.searchAlbums(query: query);
      return res;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SearchArtistsResponse> searchArtists({required String query}) async {
    try {
      final res = await _audioRepository.searchArtists(query: query);
      return res;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
