import 'dart:ui';

import 'package:hive_flutter/adapters.dart';

part 'app_config.g.dart';

@HiveType(typeId: 2)
class AppConfig {
  const AppConfig({
    required this.isDarkMode,
    this.accentColor,
    required this.isSystem,
    required this.isKateAuth,
  });

  @HiveField(0)
  final bool isDarkMode;
  @HiveField(1)
  final Color? accentColor;
  @HiveField(2)
  final bool isSystem;
  @HiveField(3)
  final bool? isKateAuth;

  AppConfig copyWith({bool? isDarkMode, Color? accentColor, bool? isSystem, bool? isKateAuth}) {
    return AppConfig(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        accentColor: accentColor ?? this.accentColor,
        isSystem: isSystem ?? this.isSystem,
        isKateAuth: isKateAuth ?? this.isKateAuth);
  }
}
