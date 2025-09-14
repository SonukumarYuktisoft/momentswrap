import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/util/constants/app_text_theme.dart';
import 'package:Xkart/util/themes/app_text_theme.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,

    /// Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.primaryColor, width: 1.0),
        textStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // /// Text Button
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
    // ),

    /// Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: AppColors.primaryColor,
        // padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // textTheme
    textTheme: AppTextTheme.lightTextTheme,
  );
}
