import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/common/utils/di/app_async_dependency.dart';

import 'common/app/app.dart';
import 'common/utils/di/scopes/app_scope.dart';
import 'data/models/user/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.vkmusic.channel.audio', // Change this
    androidNotificationChannelName: 'VKMusic Playback',
    androidNotificationOngoing: true,
  );

  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<AppConfig>(AppConfigAdapter());
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('config');

  runApp(
    AsyncDependencyWidget<AppGlobalDependency>(
      create: AppGlobalDependency.new,
      loaderBuilder: (context) => const SizedBox(),
      child: const App(),
    ),
  );
}
