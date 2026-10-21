import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B0914);
  static const surface = Color(0xFF15122A);
  static const border = Color(0xFF2B2552);
  static const primary = Color(0xFF7B4DF5);
  static const me = Color(0xFF3FD0F0);
  static const opponent = Color(0xFFFF4FA3);
  static const orange = Color(0xFFE8833A);
  static const green = Color(0xFF3DDC84);
  static const red = Color(0xFFFF5470);
  static const gold = Color(0xFFFFC93C);
  static const muted = Color(0xFF9A96B8);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ).copyWith(primary: AppColors.primary, surface: AppColors.surface);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bg,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 12,
            color: s.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted,
          )),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted,
          )),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
