import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class AppWidgets {
  static Widget buildButton({
    required String title,
    double? width,
    double? height = 50,
    Color? color,
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
            backgroundColor: color ?? AppColors.primaryColor,
            padding: padding ?? const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(30.0),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0,
             
              )
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
              ? CircularProgressIndicator(color: Colors.white)
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide(color: Colors.black45, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide(color: Colors.black45, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
       
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
