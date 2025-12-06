import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/data/models/playlist/cached_playlist.dart';
import 'package:vk_music/domain/model/player_audio.dart';

class IOCacheManager {
  final _dio = Dio();
  final _logger = Logger();

  List<PlayerAudio> readCache() {
    if (Hive.box<String>('cachedAudio').isEmpty) {
      return [];
    }

    return Hive.box<String>('cachedAudio').values
        .map((e) => PlayerAudio.fromJson(jsonDecode(e), fromCache: true))
        .toList();
  }

  void checkFilePath() {
    final toDelete = <int>[];
    final cache = Hive.box<String>(
      'cachedAudio',
    ).values.map((e) => PlayerAudio.fromJson(jsonDecode(e), fromCache: true));

    for (final audio in cache) {
      if (!File(audio.uri.toString()).existsSync()) {
        toDelete.add(audio.id);
      }
    }

    for (final id in toDelete) {
      Hive.box<String>('cachedAudio').delete(id);
    }
  }

  List<CachedPlaylist> readCachedPlaylist() {
    if (Hive.box<CachedPlaylist>('cachedPlaylist').isEmpty) {
      return [];
    }
    return Hive.box<CachedPlaylist>('cachedPlaylist').values.toList();
  }

  Future<File> downloadAudio(PlayerAudio audio, {bool addPath = true}) async {
    _logger.i('Downloading audio: $audio');
    final projectDir = await getExternalStorageDirectory();
    if (AppGlobalDependency.isKateAuth ?? false) {
      await _downloadMP3(audio: audio, dir: projectDir!);
    } else {
      await _downloadM3U8(audio: audio, dir: projectDir!);
    }

    if (addPath) {
      await Hive.box<String>('cachedAudio').put(
        audio.id,
        jsonEncode(
          audio
              .copyWith(
                uri: Uri.file(
                  '${projectDir.path}/${audio.id}.mp3'.replaceFirst('/', ''),
                ),
              )
              .toJson(),
        ),
      );
    }
    _logger.i(
      'Audio download finish at path: ${projectDir.path}/${audio.id}.mp3',
    );
    return File('${projectDir.path}/${audio.id}.mp3');
  }

  Future<CachedPlaylist> cachePlaylist(
    List<PlayerAudio> audios,
    String name,
    int id, [
    String? thumbUrl,
  ]) async {
    final projectDir = await getExternalStorageDirectory();
    final cached = readCache();
    final needToCache = audios.where((e) => !cached.any((ee) => ee.id == e.id));
    final playlist = <PlayerAudio>[];
    String? thumb;
    if (thumbUrl != null) {
      await _dio.download(thumbUrl, '${projectDir!.path}/thumbs/$name.png');
      thumb = '${projectDir.path}/thumbs/$name.png';
    }
    for (final audio in needToCache) {
      final file = await downloadAudio(audio, addPath: false);
      if (audio is PlayerAudioM3U8) {
        playlist.add(audio.toMP3().copyWith(uri: Uri.file(file.path)));
      } else {
        playlist.add(audio.copyWith(uri: Uri.file(file.path)));
      }
    }
    final model = CachedPlaylist(
      thumb: thumb,
      audios: playlist,
      name: name,
      id: id,
    );
    Hive.box<CachedPlaylist>('cachedPlaylist').put(id, model);
    return model;
  }

  Future<void> deletePlaylist(CachedPlaylist playlist) async {
    final cached = readCache();
    final needToDelete = playlist.audios.where(
      (e) => !cached.any((ee) => ee.id == e.id),
    );
    if (playlist.thumb != null) {
      File(playlist.thumb!).deleteSync();
    }
    for (final audio in needToDelete) {
      File(audio.uri.toFilePath()).deleteSync(recursive: true);
    }
    Hive.box<CachedPlaylist>('cachedPlaylist').delete(playlist.id);
  }

  Future<void> deleteAudio(PlayerAudio audio) async {
    await File(audio.uri.toFilePath()).delete();
    Hive.box<String>('cachedAudio').delete(audio.id);
  }

  Future<void> _downloadM3U8({
    required PlayerAudio audio,
    required Directory dir,
  }) async {
    await dir.create();
    final command =
        '-http_persistent false -i ${audio.uri.toString()} -c copy ${dir.path}/${audio.id}.mp3';
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (returnCode == null || !returnCode.isValueSuccess()) {
      final logs = await session.getAllLogsAsString();
      throw Exception('FFmpeg failed: $logs');
    }
  }

  Future<void> _downloadMP3({
    required PlayerAudio audio,
    required Directory dir,
  }) async {
    await dir.create();
    await _dio.download(audio.uri.toString(), '${dir.path}/${audio.id}.mp3');
  }
}
