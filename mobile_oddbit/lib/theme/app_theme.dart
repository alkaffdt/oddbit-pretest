import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme:
        const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.backgroundColor,
            )
            .copyWith(secondary: AppColors.secondary)
            .copyWith(surface: AppColors.backgroundColor)
            .copyWith(error: AppColors.errorColor),
    appBarTheme: appBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme:
        const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: Colors.black,
            )
            .copyWith(secondary: AppColors.secondary)
            .copyWith(surface: Colors.black)
            .copyWith(error: AppColors.errorColor),
  );

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
