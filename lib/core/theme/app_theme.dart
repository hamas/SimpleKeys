import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Material 3 Candy theme definition.
abstract final class AppTheme {
  static ThemeData get candyTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.candyPinkTop,
      brightness: Brightness.light,
    ).copyWith(
      surface: AppColors.background,
      primary: AppColors.candyPinkBottom,
      secondary: AppColors.candyBlueBottom,
      tertiary: AppColors.candyYellowBottom,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }
}
