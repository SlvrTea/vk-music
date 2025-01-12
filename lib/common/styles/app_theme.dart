import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:system_theme/system_theme.dart';
import 'package:vk_music/common/utils/config/app_config.dart';

class AppTheme {
  factory AppTheme.light() => AppTheme(colors: AppColors.light());

  factory AppTheme.dark() => AppTheme(colors: AppColors.dark());

  factory AppTheme.fromConfig(AppConfig config) => AppTheme(
        colors: config.isDarkMode ? AppColors.dark() : AppColors.light(),
        accentColor: Color(config.accentColor),
        brightness: config.isDarkMode ? Brightness.dark : Brightness.light,
      );

  AppTheme({
    required this.colors,
    Color? accentColor,
    Brightness? brightness,
  })  : accentColor = accentColor ?? SystemTheme.accentColor.accent,
        brightness = brightness ?? SchedulerBinding.instance.platformDispatcher.platformBrightness {
    themeData = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        color: colors.backgroundColor,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: this.accentColor,
        unselectedItemColor: Colors.grey,
      ),
      drawerTheme: DrawerThemeData(
        surfaceTintColor: colors.backgroundColor,
        backgroundColor: colors.backgroundColor,
      ),
      // filledButtonTheme: FilledButtonThemeData(style: buttonPrimary),
      // elevatedButtonTheme: ElevatedButtonThemeData(style: buttonPrimary),
      colorScheme:
          ColorScheme.fromSeed(seedColor: this.accentColor, primary: this.accentColor, brightness: this.brightness),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.backgroundColor,
        surfaceTintColor: colors.backgroundColor,
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(colors.secondaryBackground),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      scaffoldBackgroundColor: colors.backgroundColor,
      dividerTheme: DividerThemeData(
        indent: 8,
        endIndent: 8,
        thickness: 2,
        color: colors.secondaryBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: colors.secondaryBackground,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.secondaryBackground),
          borderRadius: BorderRadius.circular(8),
        ),
        focusColor: colors.secondaryBackground,
      ),
    );
  }

  Color accentColor;

  Brightness brightness;

  AppColors colors;

  late ThemeData themeData;

  TextStyle get h1 => _createStyle(
        fontSize: 32,
        figmaHeight: 38,
        fontWeight: FontWeight.bold,
      );

  TextStyle get h2 => _createStyle(
        fontSize: 26,
        figmaHeight: 32,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h3 => _createStyle(
        fontSize: 20,
        figmaHeight: 24,
        fontWeight: FontWeight.w700,
      );

  TextStyle get h4 => _createStyle(
        fontSize: 16,
        figmaHeight: 24,
        fontWeight: FontWeight.w700,
      );

  TextStyle get t1 => _createStyle(
        fontSize: 20,
        figmaHeight: 26,
        fontWeight: FontWeight.bold,
      );

  TextStyle get t2 => _createStyle(
        fontSize: 18,
        figmaHeight: 24,
        fontWeight: FontWeight.bold,
      );

  TextStyle get b1 => _createStyle(
        fontSize: 14,
        figmaHeight: 22,
      );

  TextStyle get b2 => _createStyle(
        fontSize: 14,
        figmaHeight: 22,
        fontWeight: FontWeight.bold,
      );

  TextStyle get b3 => _createStyle(
        fontSize: 16,
        figmaHeight: 24,
        fontWeight: FontWeight.normal,
      );

  TextStyle get b4 => _createStyle(
        fontSize: 16,
        figmaHeight: 24,
        fontWeight: FontWeight.bold,
      );

  TextStyle get b5 => _createStyle(
        fontSize: 12,
        figmaHeight: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get b6 => _createStyle(
        fontSize: 10,
        figmaHeight: 12,
        fontWeight: FontWeight.bold,
      );

  TextStyle get c1 => _createStyle(
        fontSize: 14,
        figmaHeight: 22,
        fontWeight: FontWeight.w100,
      );

  TextStyle get c2 => _createStyle(
        fontSize: 14,
        figmaHeight: 22,
        fontWeight: FontWeight.bold,
      );

  TextStyle get c3 => _createStyle(
        fontSize: 16,
        figmaHeight: 32,
        fontWeight: FontWeight.w400,
      );

  TextStyle get c4 => _createStyle(
        fontSize: 16,
        figmaHeight: 32,
        fontWeight: FontWeight.w400,
      );

  TextStyle _createStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? figmaHeight,
  }) {
    final height = (figmaHeight ?? fontSize) / fontSize;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? colors.mainTextColor,
      height: height,
    );
  }
}

class AppColors {
  factory AppColors.dark() => const AppColors._(
        backgroundColor: Colors.black,
        secondaryBackground: Color(0xff090b10),
        primaryButtonColor: Color.fromARGB(255, 20, 20, 20),
        mainTextColor: Color(0xFFFFFFFF),
      );

  factory AppColors.light() => const AppColors._(
        backgroundColor: Colors.white,
        secondaryBackground: Colors.blueGrey,
        primaryButtonColor: Colors.grey,
        mainTextColor: Color(0xFF192038),
      );

  final Color backgroundColor;
  final Color secondaryBackground;
  final Color primaryButtonColor;
  final Color mainTextColor;

  const AppColors._({
    required this.backgroundColor,
    required this.secondaryBackground,
    required this.primaryButtonColor,
    required this.mainTextColor,
  });
}
