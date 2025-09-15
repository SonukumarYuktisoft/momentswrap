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

  // PDF specific colors
  static const Color pdfPrimaryColor = Color(0xFF2563EB); // Blue color for PDF
  static const Color pdfGreyColor = Color(0xFF6B7280); // Grey color for PDF
  static const Color pdfLightGreyColor = Color(
    0xFFF3F4F6,
  ); // Light grey for PDF backgrounds
  static const Color pdfDarkColor = Color(
    0xFF111827,
  ); // Dark color for PDF text
  static const Color pdfSuccessColor = Color(
    0xFF10B981,
  ); // Success green for PDF
  static const Color pdfBorderColor = Color(0xFFD1D5DB); // Border color for PDF
  static const Color pdfTableBorderColor = Color(
    0xFFE5E7EB,
  ); // Table border color
  static const Color pdfHeaderBgColor = Color(
    0xFFEFF6FF,
  ); // Table header background
  static const Color pdfSuccessBgColor = Color(
    0xFFE6FFFA,
  ); // Success background
  static const Color pdfSummaryBorderColor = Color(
    0xFFDBEAFE,
  ); // Summary border color

  // Gradient combinations
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE594A3), Color(0xFFD87A8C)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF31354E), Color(0xFF404762)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFFFFCFD)],
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

  // Text color variations
  static const Color textDisabled = Color(
    0xFFBDBDBD,
  ); // Lighter gray for disabled text
  static const Color textOnPrimary =
      Colors.white; // White text on primary color
  static const Color textOnSecondary =
      Colors.white; // White text on secondary color
  static const Color textOnSurface = Color(0xFF212121); // Dark text on surfaces
  static const Color textOnBackground = Color(
    0xFF212121,
  ); // Dark text on background

  // Additional utility colors
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color cardBackground = Colors.white;
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // PDF Color Hex Strings (for PdfColor.fromHex)
  static const String pdfPrimaryHex = '#2563EB';
  static const String pdfGreyHex = '#6B7280';
  static const String pdfLightGreyHex = '#F3F4F6';
  static const String pdfDarkHex = '#111827';
  static const String pdfSuccessHex = '#10B981';
  static const String pdfBorderHex = '#D1D5DB';
  static const String pdfTableBorderHex = '#E5E7EB';
  static const String pdfHeaderBgHex = '#EFF6FF';
  static const String pdfSuccessBgHex = '#E6FFFA';
  static const String pdfSummaryBorderHex = '#DBEAFE';
}
