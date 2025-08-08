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
import '../../data/models/user/user.dart';
import '../../data/provider/audio/audio_service.dart';
import '../model/player_audio.dart';

class AudioRepository {
  AudioRepository(this._audioService, this._user);

  final AudioService _audioService;

  User? _user;

  final userAudiosNotifier = ValueNotifier<List<PlayerAudio>?>(null);

  final userAlbumsNotifier = ValueNotifier<List<Playlist>?>(null);

  void updateUser(User? user) => _user = user;

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

  Future<void> add(PlayerAudio audio) async {
    _audioService.add(ownerId: audio.ownerId, shortId: audio.id);
    userAudiosNotifier.value = [audio, ...userAudiosNotifier.value!];
  }

  Future<void> addToPlaylist(Playlist playlist, List<PlayerAudio> audios) => _audioService.addToPlaylist(
        ownerId: playlist.ownerId.toString(),
        playlistId: playlist.id,
        audioIds: audios.map((e) => '${e.ownerId}_${e.id}').join(','),
      );

  Future<void> createPlaylist(String title) async {
    final res = await _audioService.createPlaylist(ownerId: _user!.userId, title: title);
    userAlbumsNotifier.value = [res, ...userAlbumsNotifier.value!];
  }

  Future<void> delete(PlayerAudio audio) async {
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
    userAlbumsNotifier.value = [playlist.copyWith(isFollowing: true), ...userAlbumsNotifier.value!];
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

  Future<void> reorder({required int audioId, int? before, int? after}) =>
      _audioService.reorder(ownerId: _user!.userId, audioId: audioId.toString(), before: before, after: after);

  Future<Playlist> getPlaylistById({required int ownerId, required int playlistId}) =>
      _audioService.getPlaylistById(ownerId: ownerId, playlistId: playlistId);

  Future savePlaylist({
    required int playlistId,
    required int ownerId,
    required String title,
    required String description,
    List<String>? audiosToAdd,
    List<List<int>>? reorder,
  }) =>
      _audioService.savePlaylist(
        playlistId: playlistId,
        ownerId: ownerId,
        title: title,
        description: description,
        audiosToAdd: audiosToAdd?.join(','),
        reorder: reorder?.join(','),
      );

  Future<void> removeFromPlaylist({
    required int playlistId,
    required int ownerId,
    required List<String> audioIds,
  }) =>
      _audioService.removeFromPlaylist(playlistId: playlistId, ownerId: ownerId, audioIds: audioIds.join(','));
}
