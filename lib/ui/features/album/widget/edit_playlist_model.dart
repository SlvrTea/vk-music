import 'package:elementary/elementary.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';
import 'package:vk_music/domain/model/player_audio.dart';

import '../../../../data/models/playlist/playlist.dart';

abstract interface class IEditPlaylistModel extends ElementaryModel {
  Future save(
    Playlist playlist,
    String title,
    String description,
    List<String>? audiosToAdd,
    List<List<int>>? reorder,
  );

  Future<void> removeFromPlaylist({
    required int playlistId,
    required int ownerId,
    required List<String> audioIds,
  });

  Future<List<PlayerAudio>> getPlaylistAudios(Playlist playlist);
}

class EditPlaylistModel extends IEditPlaylistModel {
  EditPlaylistModel(this._audioRepository);

  final AudioRepository _audioRepository;

  @override
  Future save(
    Playlist playlist,
    String title,
    String description,
    List<String>? audiosToAdd,
    List<List<int>>? reorder,
  ) async {
    _audioRepository.savePlaylist(
      playlistId: playlist.id,
      ownerId: playlist.ownerId,
      title: title,
      description: description,
      audiosToAdd: audiosToAdd,
      reorder: reorder,
    );
  }

  @override
  Future<List<PlayerAudio>> getPlaylistAudios(Playlist playlist) async {
    final res = await _audioRepository.getAudios(
        ownerId: playlist.ownerId.toString(), isUserAudios: false, albumId: playlist.id);
    return res.items;
  }

  @override
  Future<void> removeFromPlaylist({
    required int playlistId,
    required int ownerId,
    required List<String> audioIds,
  }) async {
    _audioRepository.removeFromPlaylist(playlistId: playlistId, ownerId: ownerId, audioIds: audioIds);
  }
}
