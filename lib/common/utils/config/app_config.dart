import 'dart:ui';

import 'package:hive_flutter/adapters.dart';

part 'app_config.g.dart';

@HiveType(typeId: 2)
class AppConfig {
  const AppConfig({required this.isDarkMode, this.accentColor, required this.isSystem});

  @HiveField(0)
  final bool isDarkMode;
  @HiveField(1)
  final Color? accentColor;
  @HiveField(2)
  final bool isSystem;

  AppConfig copyWith({
    bool? isDarkMode,
    Color? accentColor,
    bool? isSystem,
  }) {
    return AppConfig(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      accentColor: accentColor,
      isSystem: isSystem ?? this.isSystem,
    );
  }
}
