import 'dart:ui';
import 'package:hive_ce/hive.dart';
import 'package:just_audio/just_audio.dart';

class AppConfig extends HiveObject {
  AppConfig({
    required this.isDarkMode,
    this.accentColor,
    required this.isSystem,
    required this.isKateAuth,
    required this.loopMode,
    this.enableShuffle = false,
  });

  final bool isDarkMode;
  final Color? accentColor;
  final bool isSystem;
  final bool? isKateAuth;
  final LoopMode loopMode;
  final bool enableShuffle;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    isDarkMode: json['isDarkMode'],
    accentColor: json['accentColor'],
    isSystem: json['isSystem'],
    isKateAuth: json['isKateAuth'],
    loopMode: LoopMode.values.byName(json['loopMode']),
    enableShuffle: json['enableShuffle'],
  );

  Map<String, dynamic> toJson() => {
    'isDarkMode': isDarkMode,
    'accentColor': accentColor,
    'isSystem': isSystem,
    'isKateAuth': isKateAuth,
    'loopMode': loopMode.name,
    'enableShuffle': enableShuffle,
  };

  AppConfig copyWith({
    bool? isDarkMode,
    Color? accentColor,
    bool? isSystem,
    bool? isKateAuth,
    LoopMode? loopMode,
    bool? enableShuffle,
  }) {
    return AppConfig(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      accentColor: accentColor ?? this.accentColor,
      isSystem: isSystem ?? this.isSystem,
      isKateAuth: isKateAuth ?? this.isKateAuth,
      loopMode: loopMode ?? this.loopMode,
      enableShuffle: enableShuffle ?? this.enableShuffle,
    );
  }
}
