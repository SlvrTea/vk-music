import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:vk_music/common/styles/app_theme.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/common/utils/di/app_async_dependency.dart';
import 'package:vk_music/common/utils/router/app_router.dart';
import 'package:vk_music/data/provider/audio/audio_service.dart';
import 'package:vk_music/data/service/interceptors/vk_interceptor.dart';
import 'package:vk_music/domain/audio/audio_repository.dart';
import 'package:vk_music/domain/auth/auth_repository.dart';

import '../../../../data/models/user/user.dart';

class AppGlobalDependency extends AppAsyncDependency {
  static String baseUrl = 'https://api.vk.com/method/';

  static double apiVersion = 5.95;

  late User? user;

  late AppConfig config;

  late AudioPlayer audioPlayer;

  late AppTheme theme;

  late final AppRouter router;

  late final Dio dio;

  late final AuthRepository authRepository;

  late final AudioRepository audioRepository;

  @override
  Future<void> initAsync(BuildContext context) async {
    final AppConfig? cfg = Hive.box('config').get('main');

    if (cfg != null) {
      config = cfg;
      theme = AppTheme.fromConfig(cfg);
    } else {
      theme = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
          ? AppTheme.dark()
          : AppTheme.light();
      config = AppConfig(
        isDarkMode: SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? true : false,
        accentColor: theme.accentColor.value,
      );
    }

    user = Hive.box('userBox').get('user');
    router = AppRouter();
    dio = _initDio();

    final audioService = AudioService(dio);

    authRepository = AuthRepository();
    audioRepository = AudioRepository(audioService, user);
    audioPlayer = AudioPlayer();
  }

  void updateConfig(AppConfig newConfig) async {
    config = newConfig;
    theme = AppTheme.fromConfig(newConfig);
    await Hive.box('config').put('main', newConfig);

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
