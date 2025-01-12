import 'package:flutter/widgets.dart';
import 'package:vk_music/data/models/artist/artist.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/data/models/response/get/get_response.dart';
import 'package:vk_music/data/models/response/get_playlists/get_playlists_response.dart';
import 'package:vk_music/data/models/response/get_recommendations/get_recommendations_response.dart';
import 'package:vk_music/data/models/response/search/search_albums_response/search_albums_response.dart';
import 'package:vk_music/data/models/response/search/search_playlists_response/search_playlists_response.dart';
import 'package:vk_music/data/models/response/search/search_response/search_response.dart';

import '../../data/models/response/search/search_artists_response/search_artists_response.dart';
import '../../data/models/song/song.dart';
import '../../data/models/user/user.dart';
import '../../data/provider/audio/audio_service.dart';

class AudioRepository {
  AudioRepository(this._audioService, this._user);

  final AudioService _audioService;

  final User? _user;

  final userAudiosNotifier = ValueNotifier<List<Song>?>(null);

  final userAlbumsNotifier = ValueNotifier<List<Playlist>?>(null);

  Future<GetResponse> getAudios({
    required String ownerId,
    required bool isUserAudios,
    int? albumId,
    int count = 1000,
    int? offset,
  }) async {
    final res = await _audioService.get(ownerId: ownerId, albumId: albumId, count: count, offset: offset);
    if (isUserAudios) {
      userAudiosNotifier.value = res.items;
    }
    return res;
  }

  Future<void> add(Song audio) async {
    _audioService.add(ownerId: audio.ownerId, shortId: audio.id);
    userAudiosNotifier.value = [audio, ...userAudiosNotifier.value!];
  }

  Future<Playlist> addToPlaylist(Playlist playlist, List<Song> audios) => _audioService.addToPlaylist(
      ownerId: _user!.userId, playlistId: playlist.id, audioIds: audios.map((e) => e.id).join(','));

  Future<Playlist> createPlaylist(String title) => _audioService.createPlaylist(ownerId: _user!.userId, title: title);

  Future<void> delete(Song audio) async {
    _audioService.delete(ownerId: _user!.userId, shortId: audio.id);
    final newContent = [...userAudiosNotifier.value!];
    newContent.remove(audio);
    userAudiosNotifier.value = newContent;
  }

  Future<void> deletePlaylist(Playlist playlist) async {
    _audioService.deletePlaylist(ownerId: _user!.userId, playlistId: playlist.id);
    final newContent = [...userAlbumsNotifier.value!];
    newContent.remove(playlist);
    userAlbumsNotifier.value = newContent;
  }

  Future<void> followPlaylist(Playlist playlist) async {
    _audioService.followPlaylist(ownerId: playlist.ownerId.toString(), playlistId: playlist.id);
    userAlbumsNotifier.value = [playlist, ...userAlbumsNotifier.value!];
  }

  Future<GetPlaylistsResponse> getPlaylists({int? count, int? offset}) async {
    final res = await _audioService.getPlaylists(ownerId: _user!.userId, count: count, offset: offset);
    userAlbumsNotifier.value = res.items;
    return res;
  }

  Future<GetRecommendationsResponse> getRecommendations({int? count, int? offset}) =>
      _audioService.getRecommendation(userId: _user!.userId, count: count, offset: offset);

  Future<SearchResponse> search({required String query, int? count, int? offset}) =>
      _audioService.search(query: query, count: count, offset: offset);

  Future<SearchAlbumsResponse> searchAlbums({required String query, int? count, int? offset}) =>
      _audioService.searchAlbums(query: query, count: count, offset: offset);

  Future<SearchArtistsResponse> searchArtists({required String query, int? count, int? offset}) =>
      _audioService.searchArtist(query: query, count: count, offset: offset);

  Future<SearchPlaylistsResponse> searchPlaylists({required String query, int? count, int? offset}) =>
      _audioService.searchPlaylists(query: query, count: count, offset: offset);

  Future<Artist> getArtistById(String artistId) => _audioService.getArtistById(artistId: artistId);

  Future<GetResponse> getAudiosByArtist({required String artistId, int? count, int? offset}) =>
      _audioService.getAudiosByArtist(artistId: artistId, count: count, offset: offset);

  Future<GetPlaylistsResponse> getAlbumsByArtist({required String artistId, int? count, int? offset}) =>
      _audioService.getAlbumsByArtist(artistId: artistId, count: count, offset: offset);
}
