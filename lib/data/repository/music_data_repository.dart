
import 'package:vk_music/data/service/vk_audio_service.dart';
import 'package:vk_music/domain/models/song.dart';
import 'package:vk_music/domain/repository/music_repository.dart';

import '../../domain/models/artist.dart';
import '../../domain/models/playlist.dart';

class MusicDataRepository implements MusicRepository {
  final VKAudioService _api;

  MusicDataRepository(this._api);

  @override
  Future get(String args) => _api.get(args);

  @override
  Future getCurrentUserAudios({int? count, int? offset}) => _api.getCurrentUserAudios(count: count, offset: offset);

  @override
  Future getPlaylistAudios(Playlist playlist) => _api.getPlaylistAudios(playlist);

  @override
  Future getArtist(String id) => _api.getArtistById(id);

  @override
  Future getAlbumsByArtist(Artist artist) => _api.getAlbumsByArtist(artist);

  @override
  Future getAudiosByArtist(Artist artist) => _api.getAudiosByArtist(artist);

  @override
  Future<void> deleteAudio(Song song) => _api.delete(song);

  @override
  Future<void> addAudio(Song song) => _api.add(song);

  @override
  Future<void> reorder(Song song, {String? before, String? after}) => _api.reorder(song, before: before, after: after);

  @override
  Future getPlaylists(String args) => _api.getPlaylists();

  @override
  Future getPlaylistMusic(Playlist playlist) => _api.getPlaylistAudios(playlist);

  @override
  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete}) =>
      _api.deleteFromPlaylist(playlist: playlist, songsToDelete: songsToDelete);

  @override
  Future savePlaylist(
      {required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder}
  ) => _api.savePlaylist(playlist: playlist, title: title, description: description, songsToAdd: songsToAdd, reorder: reorder);

  @override
  Future<dynamic> addAudiosToPlaylist(Playlist playlist, List<Song> audiosToAdd) => _api.addToPlaylist(playlist, audiosToAdd);

  @override
  Future search(String q, {int? count, int? offset}) => _api.search(q, count: count, offset: offset);

  @override
  Future searchAlbum(String q) => _api.searchAlbum(q);

  @override
  Future searchPlaylist(String q) => _api.searchPlaylists(q);

  @override
  Future getRecommendations({int? offset}) => _api.getRecommendations(offset: offset);

  @override
  Future<void> followPlaylist(Playlist playlist) => _api.followPlaylist(playlist);

  @override
  Future<void> deletePlaylist(Playlist playlist) => _api.deletePlaylist(playlist);
}