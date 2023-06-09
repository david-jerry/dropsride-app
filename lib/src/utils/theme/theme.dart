import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropsrideTheme {
  /// Set theme data from this either using the [dropsrideLightTheme] or [dropsrideDarkTheme]
  static final dropsrideLightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData.light().textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primaryColor,
    ).copyWith(background: AppColors.white300),

    // general input decoration style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.whiteColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p12),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: AppSizes.p2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p12),
        borderSide: const BorderSide(
          color: AppColors.grey200,
          width: AppSizes.p2,
        ),
      ),
      focusColor: AppColors.grey200,
    ),

    // elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.p12),
        ),
        elevation: AppSizes.p8,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.buttonHeight / 2.7,
        ),
      ),
    ),
  );

  static final dropsrideDarkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.secondaryColor,
    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData.dark().textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      elevation: 0,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primaryColor,
    ).copyWith(background: AppColors.secondaryColor),

    // general input decoration theme style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey400,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p16),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: AppSizes.p2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.p16),
        borderSide: const BorderSide(
          color: AppColors.grey200,
          width: AppSizes.p2,
        ),
      ),
      focusColor: AppColors.white300,
    ),

    // elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.p12),
        ),
        elevation: AppSizes.p8,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.buttonHeight / 2.7,
        ),
      ),
    ),
  );
}
