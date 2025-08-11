import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new_audio/ffmpeg_kit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vk_music/common/utils/di/scopes/app_scope.dart';
import 'package:vk_music/domain/model/player_audio.dart';

class IOCacheManager {
  final _dio = Dio();
  final _logger = Logger();

  List<PlayerAudio> readCache() {
    if (Hive.box<String>('cachedAudio').isEmpty) {
      return [];
    }

    return Hive.box<String>('cachedAudio').values.map((e) => PlayerAudio.fromJson(jsonDecode(e))).toList();
  }

  Future<File> downloadAudio(PlayerAudio audio) async {
    _logger.i('Downloading audio: $audio');
    final projectDir = await getExternalStorageDirectory();
    if (AppGlobalDependency.isKateAuth ?? false) {
      await _downloadMP3(audio: audio, dir: projectDir!);
    } else {
      await _downloadM3U8(audio: audio, dir: projectDir!);
    }

    await Hive.box<String>('cachedAudio').put(
      audio.id,
      jsonEncode(audio.copyWith(uri: Uri.file('${projectDir.path}/${audio.id}.mp3')).toJson()),
    );
    _logger.i('Audio download finish');
    return File('${projectDir.path}/${audio.id}.mp3');
  }

  Future<void> deleteAudio(PlayerAudio audio) async {
    await File(audio.uri.toFilePath()).delete();
    Hive.box<String>('cachedAudio').delete(audio.id);
  }

  Future<void> _downloadM3U8({required PlayerAudio audio, required Directory dir}) async {
    await dir.create();
    final command = '-http_persistent false -i ${audio.uri.toString()} -c copy ${dir.path}/${audio.id}.mp3';
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (returnCode == null || !returnCode.isValueSuccess()) {
      final logs = await session.getAllLogsAsString();
      throw Exception('FFmpeg failed: $logs');
    }
  }

  Future<void> _downloadMP3({required PlayerAudio audio, required Directory dir}) async {
    await dir.create();
    await _dio.download(audio.uri.toString(), '${dir.path}/${audio.id}.mp3');
  }
}
