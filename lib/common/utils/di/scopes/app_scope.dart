import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/common/utils/di/app_async_dependency.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/data/provider/audio/audio_service.dart';
import 'package:vk_music/data/service/interceptors/vk_interceptor.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';
import 'package:vk_music/domain/auth/auth_repository.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

import '../../../../data/models/user/user.dart';
import '../../../../domain/audio_player/audio_player_controller.dart';

class AppGlobalDependency extends AppAsyncDependency {
  static String baseUrl = 'https://api.vk.com/method/';

  static double apiVersion = 5.95;

  late User? user;

  late AppConfig config;

  late AppTheme theme;

  late Color systemColor;

  late final AppRouter router;

  late final Dio dio;

  late final AuthRepository authRepository;

  late final AudioRepository audioRepository;

  late final AppAudioPlayer audioPlayer;

  @override
  Future<void> initAsync(BuildContext context) async {
    final AppConfig? cfg = Hive.box('config').get('main');
    systemColor = SystemTheme.accentColor.accent;

    if (cfg != null) {
      config = cfg;
      theme = AppTheme.fromConfig(cfg);
    } else {
      theme = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? AppTheme.dark()
          : AppTheme.light();
      config = AppConfig(
        isDarkMode: SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? true : false,
        accentColor: systemColor,
        isSystem: true,
      );
    }

    final userBox = Hive.box('userBox');
    user = userBox.get('user');
    router = AppRouter();
    dio = _initDio();

    final audioService = AudioService(dio);

    authRepository = AuthRepository();
    audioRepository = AudioRepository(audioService, user);
    audioPlayer = AppAudioPlayer()
      ..setShuffleModeEnabled(userBox.get('shuffle'))
      ..setLoopMode(LoopMode.values[userBox.get('loopMode')]);
  }

  Future<void> updateConfig(AppConfig newConfig) async {
    config = newConfig;
    theme = AppTheme.fromConfig(config);
    await Hive.box('config').delete('main');
    await Hive.box('config').put('main', config);
    notifyListeners();
  }

  Dio _initDio() {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ))
      ..interceptors.addAll([
        VKInterceptor(apiVersion: apiVersion, user: user),
        PrettyDioLogger(
          responseBody: false,
          error: true,
          compact: true,
          enabled: kDebugMode,
        ),
      ]);
    return dio;
  }
}

extension DepContextExtension on BuildContext {
  AppGlobalDependency get global => read<AppGlobalDependency>();
}
