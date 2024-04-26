
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'core/domain/models/user.dart';
import 'core/internal/app.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const App());
}