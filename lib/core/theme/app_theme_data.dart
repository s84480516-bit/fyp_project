import 'app_colors.dart';
import 'app_text_style.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightSurface,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.lightSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.lightText,
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headingLarge.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: AppTextStyles.headingMedium.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: AppTextStyles.headingSmall.copyWith(
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.lightText,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.lightText,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.lightSubText,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightText,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.lightSubText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.darkText,
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headingLarge.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: AppTextStyles.headingMedium.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: AppTextStyles.headingSmall.copyWith(
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkSubText),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.darkSubText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
