import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/common/utils/extensions/widget_model_extension.dart';

import '../../../data/models/playlist/playlist.dart';
import '../../../data/models/song/song.dart';
import 'search_screen_model.dart';
import 'search_screen_widget.dart';

enum SearchState { recommendations, search }

abstract interface class ISearchScreenWidgetModel implements IWidgetModel {
  MediaQueryData get mediaQuery;

  EntityValueListenable<List<Song>> get recommendations;

  EntityValueListenable<List<Song>> get audios;

  EntityValueListenable<int> get audiosCount;

  EntityValueListenable<List<Playlist>> get playlists;

  EntityValueListenable<int> get playlistsCount;

  EntityValueListenable<List<Playlist>> get albums;

  EntityValueListenable<int> get albumsCount;

  EntityValueListenable<SearchState> get state;

  TextEditingController get searchController;

  Future<void> getRecommendations();

  Future<void> search({required String query});

  Future<void> onLoadMoreRecommendations({int? offset});

  Future<void> searchAudios({required String query});

  Future<void> searchPlaylists({required String query});

  Future<void> searchAlbums({required String query});
}

SearchScreenWidgetModel defaultSearchScreenWidgetModelFactory(BuildContext context) =>
    SearchScreenWidgetModel(SearchScreenModel(
      context.global.audioRepository,
    ));

class SearchScreenWidgetModel extends WidgetModel<SearchScreen, ISearchScreenModel>
    implements ISearchScreenWidgetModel {
  SearchScreenWidgetModel(super.model);

  @override
  MediaQueryData get mediaQuery => wmMediaQuery;

  final _recommendationsEntity = EntityStateNotifier<List<Song>>();

  final _audiosEntity = EntityStateNotifier<List<Song>>();

  final _audiosCountEntity = EntityStateNotifier<int>();

  final _playlistsEntity = EntityStateNotifier<List<Playlist>>();

  final _playlistCountEntity = EntityStateNotifier<int>();

  final _albumsEntity = EntityStateNotifier<List<Playlist>>();

  final _albumsCountEntity = EntityStateNotifier<int>();

  final _widgetStateEntity = EntityStateNotifier<SearchState>();

  final _searchController = TextEditingController();

  @override
  EntityValueListenable<List<Song>> get recommendations => _recommendationsEntity;

  @override
  EntityValueListenable<List<Song>> get audios => _audiosEntity;

  @override
  EntityValueListenable<int> get audiosCount => _audiosCountEntity;

  @override
  EntityValueListenable<List<Playlist>> get playlists => _playlistsEntity;

  @override
  EntityValueListenable<int> get playlistsCount => _playlistCountEntity;

  @override
  EntityValueListenable<List<Playlist>> get albums => _albumsEntity;

  @override
  EntityValueListenable<int> get albumsCount => _albumsCountEntity;

  @override
  EntityValueListenable<SearchState> get state => _widgetStateEntity;

  @override
  TextEditingController get searchController => _searchController;

  @override
  void initWidgetModel() {
    _searchController.text = widget.initialQuery ?? '';
    _initAsync();
    super.initWidgetModel();
  }

  void _initAsync() async {
    if (_searchController.text.isNotEmpty) {
      await search(query: _searchController.text);
      return;
    }
    await Future.wait([
      getRecommendations(),
    ]);
  }

  @override
  Future<void> getRecommendations() async {
    _recommendationsEntity.loading();
    final res = await model.getRecommendations();
    _recommendationsEntity.content(res);
    _widgetStateEntity.content(SearchState.recommendations);
  }

  @override
  Future<void> onLoadMoreRecommendations({int? offset}) async {
    final res = await model.getRecommendations(offset: offset, count: _recommendationsEntity.value.data!.length + 30);
    final recs = [..._recommendationsEntity.value.data!, ...res];
    _recommendationsEntity.content(recs);
  }

  @override
  Future<void> search({required String query}) async {
    await Future.wait([
      searchAudios(query: query),
      searchPlaylists(query: query),
      searchAlbums(query: query),
    ]);
    _widgetStateEntity.content(SearchState.search);
  }

  @override
  Future<void> searchAudios({required String query}) async {
    _audiosEntity.loading();
    final res = await model.search(query: query);
    _audiosCountEntity.content(res.count);
    _audiosEntity.content(res.items);
  }

  @override
  Future<void> searchPlaylists({required String query}) async {
    _playlistsEntity.loading();
    final res = await model.searchPlaylists(query: query);
    _playlistsEntity.content(res.items);
    _playlistCountEntity.content(res.count);
  }

  @override
  Future<void> searchAlbums({required String query}) async {
    _albumsEntity.loading();
    final res = await model.searchAlbums(query: query);
    _albumsEntity.content(res.items);
    _albumsCountEntity.content(res.count);
  }
}
