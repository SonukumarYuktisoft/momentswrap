import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/services/shared_preferences_services.dart';

class AuthUtils {
  /// For actions like "Add to Cart"
  static Future<void> runIfLoggedIn(Function action) async {
    final isLoggedIn = await SharedPreferencesServices.getIsLoggedIn();
    if (isLoggedIn) {
      action();
    } else {
      _showLoginDialog();
    }
  }

  /// For actions like "Buy Now" → check login + address
  static Future<void> runIfLoggedInAndHasAddress(Function action) async {
    final isLoggedIn = await SharedPreferencesServices.getIsLoggedIn();

    if (!isLoggedIn) {
      // Not logged in → redirect to login
      _showLoginDialog();
      return;
    }

    // Already logged in → check address
    final addresses = await SharedPreferencesServices.getAddresses();
    if (addresses.isEmpty) {
      // No address → redirect to profile/address screen
      Get.toNamed(
        AppRoutes.editProfileScreen,
      ); // <-- yahan aap apna route set karo
      return;
    }

    // ✅ Both login + address available
    action();
  }

  /// Common login dialog
  static void _showLoginDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Not Logged In'),
        content: const Text('Please log in to continue.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.loginScreen);
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}
