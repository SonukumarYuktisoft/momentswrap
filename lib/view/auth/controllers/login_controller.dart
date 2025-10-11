import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/auth/models/login_model.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:Xkart/services/shared_preferences_services.dart';

class LoginController extends GetxController {
  // Define your login-related methods and properties here
  ApiServices _apiServices = ApiServices();
  RxBool isLoading = false.obs;
  RxBool toggle = true.obs;

  /// Toggles the password visibility
  void changeToggle() {
    toggle.value = !toggle.value;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        dio.Response? response = await _apiServices.requestPostForApi(
          authToken: false,
          url:
              'https://moment-wrap-backend.vercel.app/api/customer/login-customer',
          dictParameter: {
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          },
        );
        if (response?.statusCode == 200 && response?.data != null) {
          final responseData = LoginModel.fromJson(response!.data);
          if (responseData.message == 'Login successful') {
            Get.snackbar(
              'Login Success',
              'Welcome ${responseData.customer.firstName} ${responseData.customer.lastName}!',
              backgroundColor: Colors.green.withOpacity(0.5),
            );
            String userToken = responseData.token;
            String userId = responseData.customer.id;
            String userEmail = responseData.customer.email;
            String userProfileImage = responseData.customer.profileImage;
            String userName =
                '${responseData.customer.firstName} ${responseData.customer.lastName}';
            List<Map<String, dynamic>> addresses =
                (responseData.customer.addresses as List)
                    .map((e) => Map<String, dynamic>.from(e as Map))
                    .toList();
            String userPhone = responseData.customer.phone;
            await SharedPreferencesServices.setJwtToken(userToken);
            await SharedPreferencesServices.setUserName(userName);
            await SharedPreferencesServices.setIsLoggedIn(true);
            await SharedPreferencesServices.setUserId(userId);
            await SharedPreferencesServices.setUserEmail(userEmail);
            await SharedPreferencesServices.setUserProfileImage(
              userProfileImage,
            );
            await SharedPreferencesServices.setLoginDate(DateTime.now());
            await SharedPreferencesServices.setUserId(userId);
            await SharedPreferencesServices.saveAddresses(addresses);
            await SharedPreferencesServices.setPhoneNumber(userPhone);
            Get.offAllNamed(AppRoutes.bottomNavigation);
          } else {
            Get.snackbar(
              'Login Error',
              response?.statusMessage ?? 'Unknown error',
            );
          }
        } else {
          Get.snackbar(
            'Login Error',
            response?.statusMessage ?? 'Unknown error',
          );
        }
      } catch (e) {
        Get.snackbar(
          'Login Error',
          e.toString(),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        // Use logging framework instead of print
        debugPrint(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      final token = await SharedPreferencesServices.getJwtToken();
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/logout-customer',
        dictParameter: {},
      );
      if (response?.statusCode == 200 && response?.data != null) {
        final success = response?.data['success'] == true;
        if (success) {
          await SharedPreferencesServices.clearAll();
          Get.snackbar(
            'Logout Success',
            response?.data['message'] ?? 'Logged out successfully',
            backgroundColor: const Color.fromRGBO(
              76,
              175,
              80,
              0.5,
            ), // Colors.green.withValues(76, 175, 80, 0.5)
          );
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          Get.snackbar(
            'Logout Error',
            response?.data['message'] ?? 'Unknown error',
            backgroundColor: const Color.fromRGBO(
              244,
              67,
              54,
              0.5,
            ), // Colors.red.withValues(244, 67, 54, 0.5)
          );
        }
      } else {
        Get.snackbar(
          'Logout Error',
          response?.statusMessage ?? 'Unknown error',
          backgroundColor: const Color.fromRGBO(
            244,
            67,
            54,
            0.5,
          ), // Colors.red.withValues(244, 67, 54, 0.5)
        );
      }
    } catch (e) {
      Get.snackbar(
        'Logout Error',
        e.toString(),
        backgroundColor: const Color.fromRGBO(
          244,
          67,
          54,
          0.5,
        ), // Colors.red.withValues(244, 67, 54, 0.5)
      );
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
