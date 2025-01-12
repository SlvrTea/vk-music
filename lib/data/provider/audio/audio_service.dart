import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vk_music/data/models/artist/artist.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/data/models/response/get/get_response.dart';
import 'package:vk_music/data/models/response/get_playlists/get_playlists_response.dart';
import 'package:vk_music/data/models/response/get_recommendations/get_recommendations_response.dart';
import 'package:vk_music/data/models/response/search/search_albums_response/search_albums_response.dart';
import 'package:vk_music/data/models/response/search/search_artists_response/search_artists_response.dart';
import 'package:vk_music/data/models/response/search/search_playlists_response/search_playlists_response.dart';
import 'package:vk_music/data/models/response/search/search_response/search_response.dart';

part 'audio_service.g.dart';

@RestApi()
abstract class AudioService {
  factory AudioService(Dio dio, {String? baseUrl}) = _AudioService;

  @GET('audio.add')
  Future<void> add({
    @Query('owner_id') required int ownerId,
    @Query('audio_id') required int shortId,
  });

  @GET('audio.addToPlaylist')
  Future<Playlist> addToPlaylist({
    @Query('owner_id') required String ownerId,
    @Query('playlist_id') required int playlistId,
    @Query('audio_ids') required String audioIds,
  });

  @GET('audio.createPlaylist')
  Future<Playlist> createPlaylist({
    @Query('owner_id') required String ownerId,
    @Query('title') required String title,
  });

  @GET('audio.delete')
  Future<void> delete({
    @Query('owner_id') required String ownerId,
    @Query('audio_id') required int shortId,
  });

  @GET('audio.deletePlaylist')
  Future<void> deletePlaylist(
      {@Query('owner_id') required String ownerId, @Query('playlist_id') required int playlistId});

  @GET('audio.followPlaylist')
  Future<void> followPlaylist({
    @Query('owner_id') required String ownerId,
    @Query('playlist_id') required int playlistId,
  });

  @GET('audio.get')
  Future<GetResponse> get({
    @Query('owner_id') required String ownerId,
    @Query('album_id') int? albumId,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.getAlbumsByArtist')
  Future<GetPlaylistsResponse> getAlbumsByArtist({
    @Query('artist_id') required String artistId,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.getAudiosByArtist')
  Future<GetResponse> getAudiosByArtist({
    @Query('artist_id') required String artistId,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.getPlaylists')
  Future<GetPlaylistsResponse> getPlaylists({
    @Query('owner_id') required String ownerId,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.getRecommendations')
  Future<GetRecommendationsResponse> getRecommendation({
    @Query('user_id') String? userId,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.search')
  Future<SearchResponse> search({
    @Query('q') required String query,
    @Query('count') int? count,
    @Query('offset') int? offset,
    @Query('auto_complete') int autoComplete = 1,
  });

  @GET('audio.searchAlbums')
  Future<SearchAlbumsResponse> searchAlbums({
    @Query('q') required String query,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.searchArtists')
  Future<SearchArtistsResponse> searchArtist({
    @Query('q') required String query,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.searchPlaylists')
  Future<SearchPlaylistsResponse> searchPlaylists({
    @Query('q') required String query,
    @Query('count') int? count,
    @Query('offset') int? offset,
  });

  @GET('audio.getArtistById')
  Future<Artist> getArtistById({
    @Query('artist_id') required String artistId,
  });
}
