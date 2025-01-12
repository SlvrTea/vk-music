import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/artist/artist.dart';

import '../../../data/models/playlist/playlist.dart';
import '../../../data/models/song/song.dart';
import 'artist_screen.dart';
import 'artist_screen_model.dart';

abstract interface class IArtistScreenWidgetModel implements IWidgetModel {
  EntityValueListenable<Artist> get artist;

  EntityValueListenable<List<Song>> get audios;

  EntityValueListenable<List<Playlist>> get albums;

  EntityValueListenable<List<Playlist>> get playlists;
}

ArtistScreenWidgetModel defaultArtistScreenWidgetModelFactory(BuildContext context) =>
    ArtistScreenWidgetModel(ArtistScreenModel(
      context.global.audioRepository,
    ));

class ArtistScreenWidgetModel extends WidgetModel<ArtistScreen, IArtistScreenModel>
    implements IArtistScreenWidgetModel {
  ArtistScreenWidgetModel(super.model);

  final _artistEntity = EntityStateNotifier<Artist>();

  @override
  EntityValueListenable<Artist> get artist => _artistEntity;

  final _audiosEntity = EntityStateNotifier<List<Song>>();

  @override
  EntityValueListenable<List<Song>> get audios => _audiosEntity;

  final _albumsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<Playlist>> get albums => _albumsEntity;

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  @override
  EntityValueListenable<List<Playlist>> get playlists => _playlistsEntity;

  @override
  void initWidgetModel() {
    _initAsync();
    super.initWidgetModel();
  }

  Future<void> _initAsync() async {
    await Future.wait([
      _loadArtist(),
      _loadAudio(),
      _loadAlbums(),
    ]);

    _loadPlaylists();

    final albums = await model.getAlbumsByArtist(widget.artistId);
    _albumsEntity.content(albums);
  }

  Future<void> _loadArtist() async {
    try {
      final artist = await model.getArtist(widget.artistId);
      _artistEntity.content(artist);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> _loadAudio() async {
    try {
      final audios = await model.getAudiosByArtist(widget.artistId);
      _audiosEntity.content(audios);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> _loadAlbums() async {
    try {
      final albums = await model.getAlbumsByArtist(widget.artistId);
      _albumsEntity.content(albums);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> _loadPlaylists() async {
    try {
      final playlists = await model.getPlaylists(_artistEntity.value.data!.name);
      _playlistsEntity.content(playlists);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
