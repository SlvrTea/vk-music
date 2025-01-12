import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:vk_music/data/models/playlist/playlist.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';

abstract interface class IAlbumsScreenModel extends ElementaryModel {
  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier;
}

class AlbumsScreenModel extends IAlbumsScreenModel {
  AlbumsScreenModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  ValueNotifier<List<Playlist>?> get userPlaylistsNotifier => _audioRepository.userAlbumsNotifier;
}
