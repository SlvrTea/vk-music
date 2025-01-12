import 'package:hive_flutter/adapters.dart';

part 'app_config.g.dart';

@HiveType(typeId: 2)
class AppConfig {
  const AppConfig({required this.isDarkMode, required this.accentColor});

  @HiveField(0)
  final bool isDarkMode;
  @HiveField(1)
  final int accentColor;

  AppConfig copyWith({
    bool? isDarkMode,
    int? accentColor,
  }) {
    return AppConfig(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
