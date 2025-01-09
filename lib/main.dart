import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'core/domain/models/user.dart';
import 'core/internal/app.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.vkmusic.channel.audio', // Change this
    androidNotificationChannelName: 'VKMusic Playback',
    androidNotificationOngoing: true,
  );
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const App());
}
