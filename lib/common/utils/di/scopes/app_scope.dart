import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
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
import 'package:vk_music/domain/cache_manager/cache_manager.dart';
import 'package:vk_music/ui/theme/app_theme.dart';

import '../../../../data/models/user/user.dart';
import '../../../../domain/audio_player/audio_player_controller.dart';

class AppGlobalDependency extends AppAsyncDependency {
  static const baseUrl = 'https://api.vk.com/method/';

  static const apiVersion = 8.143;

  static bool? isKateAuth;

  late User? user;

  late AppConfig config;

  late AppTheme theme;

  late Color systemColor;

  late final AppRouter router;

  late final Dio dio;

  late final AuthRepository authRepository;

  late final AudioRepository audioRepository;

  late final AppAudioPlayerController audioPlayer;

  late final IOCacheManager cacheManager;

  @override
  Future<void> initAsync(BuildContext context) async {
    _initConfig();
    user = Hive.box<User>('user').get('user');
    router = AppRouter();
    authRepository = AuthRepository();
    _initDio();
    cacheManager = IOCacheManager()..readCachedPlaylist();
    final audioService = AudioService(dio);
    audioPlayer = AppAudioPlayerController(config);
    audioRepository = AudioRepository(audioService, user, cacheManager);
  }

  Future<void> updateConfig(AppConfig newConfig) async {
    config = newConfig;
    theme = AppTheme.fromConfig(config);
    await Hive.box<AppConfig>('config').delete('main');
    await Hive.box<AppConfig>('config').put('main', config);
    notifyListeners();
  }

  void updateUser(User user) {
    Hive.box<User>('user').put('user', user);
    this.user = user;
    audioRepository.updateUser(user);
    (dio.interceptors.firstWhere((e) => e is VKInterceptor) as VKInterceptor)
            .user =
        user;
    notifyListeners();
  }

  void _initConfig() {
    final AppConfig? cfg = Hive.box<AppConfig>('config').get('main');
    systemColor = SystemTheme.accentColor.accent;
    if (cfg != null) {
      config = cfg;
      theme = AppTheme.fromConfig(cfg);
    } else {
      theme =
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark
          ? AppTheme.dark()
          : AppTheme.light();
      config = AppConfig(
        isDarkMode:
            SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? true
            : false,
        accentColor: systemColor,
        isSystem: true,
        isKateAuth: null,
        loopMode: LoopMode.off,
      );
    }
  }

  void _initDio() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.addAll([
      VKInterceptor(
        authRepository,
        apiVersion: apiVersion,
        user: user,
        dio: dio,
        updateUser: updateUser,
      ),
      PrettyDioLogger(
        responseBody: false,
        error: true,
        compact: true,
        enabled: kDebugMode,
      ),
    ]);
  }
}

extension DepContextExtension on BuildContext {
  AppGlobalDependency get global => read<AppGlobalDependency>();
}
