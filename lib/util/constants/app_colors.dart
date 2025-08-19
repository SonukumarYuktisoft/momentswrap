import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
  static const Color primaryColor =  Colors.pinkAccent;
  static const Color secondaryColor = Color(0xFFF6F6F6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);

  //gradient colors
  static const Gradient gradientStartColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE61046), Color(0xFFF6F6F6)],
  );
  static const Gradient gradientEndColor = LinearGradient(
    colors: [Color(0xFFF6F6F6), Color(0xFFE61046)],
  );
}
