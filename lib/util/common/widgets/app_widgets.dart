import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppWidgets {
  static Widget buildButton({
    required String title,
    double? width,
    double? height = 50,
    Color? color,
    Color? bgColor,

    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required void Function() onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? Colors.white,
            foregroundColor: color ?? Colors.black,
            padding: padding ?? const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(30.0),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
              : Text(title),
        ),
      ),
    );
  }

  /// Outlined Button
  static Widget buildOutlinedButton({
    required String title,
    double? width,
    double? height = 60.0,
    Color? color,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required void Function() onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            // backgroundColor: color ?? AppColors.primaryColor,
            padding: padding ?? const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(30.0),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    // shimmer length
                    padding: padding ?? const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius ?? BorderRadius.circular(30.0),
                    ),

                    height: 50,
                    color: Colors.white,
                  ),
                )
              : Text(title),
        ),
      ),
    );
  }

  // Text Form Field
  static Widget buildTextFormField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
    required TextEditingController controller,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        // --- DEFAULT (no border look) ---
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // --- Normal state ---
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        // --- Focused state ---
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),

        // --- Error state ---
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),

        // --- Focused + Error state ---
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),

        errorStyle: const TextStyle(color: Colors.white, fontSize: 12),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
