import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle().copyWith(fontSize: 18, fontWeight: FontWeight.w600),

    titleLarge: const TextStyle().copyWith(fontSize: 16, color: AppColors.textColor, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle().copyWith(fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle().copyWith(fontSize: 12, color: AppColors.textColor, fontWeight: FontWeight.w400),  

    bodyLarge: const TextStyle().copyWith(fontSize: 16, color: AppColors.textColor, fontWeight: FontWeight.w500),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle().copyWith(fontSize: 12, color: AppColors.textColor, fontWeight: FontWeight.w400),

    labelLarge: const TextStyle().copyWith(fontSize: 12, color: AppColors.textColor, fontWeight: FontWeight.w500),
    labelMedium: const TextStyle().copyWith(fontSize: 12, color: AppColors.textColor.withOpacity(0.5), fontWeight: FontWeight.w400),
    labelSmall: const TextStyle().copyWith(fontSize: 12, color: AppColors.textColor, fontWeight: FontWeight.w400),
  );
}
