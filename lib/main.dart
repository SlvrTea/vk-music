import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:system_theme/system_theme.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/common/utils/di/app_async_dependency.dart';
import 'package:vk_music/data/models/playlist/cached_playlist.dart';
import 'package:vk_music/hive/hive_registrar.g.dart';

import 'common/app/app.dart';
import 'common/utils/di/scopes/app_scope.dart';
import 'data/models/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.vkmusic.channel.audio',
    androidNotificationChannelName: 'VKMusic Playback',
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox<User>('user');
  await Hive.openBox<AppConfig>('config');
  await Hive.openBox<String>('cachedAudio');
  await Hive.openBox<CachedPlaylist>('cachedPlaylist');

  SystemTheme.fallbackColor = Colors.cyanAccent;

  runApp(
    AsyncDependencyWidget<AppGlobalDependency>(
      create: AppGlobalDependency.new,
      loaderBuilder: (context) => const SizedBox(),
      child: const App(),
    ),
  );
}
