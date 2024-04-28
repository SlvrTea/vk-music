import 'package:flutter/material.dart';

class MainTheme {
  static final themeData = ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black
      ),
      snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey
      ),
      drawerTheme: const DrawerThemeData(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 20, 20, 20)),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 20, 20, 20)),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          )
      ),
      colorScheme: ColorScheme.fromSeed(
        background: Colors.black,
        seedColor: Colors.purple,
        primary: Colors.purpleAccent,
        brightness: Brightness.dark,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
      )
  );
}