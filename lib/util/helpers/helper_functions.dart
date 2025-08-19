import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class HelperFunctions {

  static String formatCurrency(double amount) {
    return "\$${amount.toStringAsFixed(2)}";
  }

  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  static void showSnackbar(String s, String m, {
    required String title,
    required String message,
    Color? backgroundColor,
    bool isError = false
  }) {
    Get.snackbar(title, message,
    backgroundColor: backgroundColor ?? Colors.black,
    animationDuration: Duration(milliseconds: 300));
  
  }

  static void showDialog({
    required String title,
    required String content,
    VoidCallback? onConfirm,
    VoidCallback? onCancel
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onCancel ?? () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: onConfirm ?? () => Get.back(),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

// utility functions
static double screenSize() {
  return Get.width;
}

  static double screenWidth() {
    return Get.width;
  }

  static double screenHeight() {
    return Get.height;
  }
}