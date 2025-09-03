import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFE594A3);
  static const Color secondaryColor = Color(0xFF31354E);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color accentColor = Colors.white;
  static const Color textColor = Color(0xFF212121);

  // Additional theme colors derived from the main palette
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradient combinations
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE594A3),
      Color(0xFFD87A8C),
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF31354E),
      Color(0xFF404762),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFFFFCFD),
    ],
  );

  // Opacity variations
  static Color get primaryLight => primaryColor.withOpacity(0.1);
  static Color get primaryMedium => primaryColor.withOpacity(0.3);
  static Color get primaryDark => primaryColor.withOpacity(0.8);

  static Color get secondaryLight => secondaryColor.withOpacity(0.1);
  static Color get secondaryMedium => secondaryColor.withOpacity(0.3);
  static Color get secondaryDark => secondaryColor.withOpacity(0.8);

  // Text colors
  static Color get textPrimary => textColor;
  static Color get textSecondary => textColor.withOpacity(0.7);
  static Color get textHint => textColor.withOpacity(0.5);

  // Surface colors
  static Color get surface => accentColor;
  static Color get surfaceVariant => backgroundColor;
  static Color get surfaceTint => primaryColor.withOpacity(0.05);
}