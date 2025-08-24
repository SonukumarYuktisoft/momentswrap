import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:momentswrap/models/auth_model/login_model.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:momentswrap/services/shared_preferences_services.dart';

class ForgetController extends GetxController {
  // Define your login-related methods and properties here
  ApiServices _apiServices = ApiServices();
  RxBool isLoading = false.obs;
  RxBool toggle = true.obs;

  /// Toggles the password visibility
  void changeToggle() {
    toggle.value = !toggle.value;
  }

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> forgetFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (forgetFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        dio.Response response = await _apiServices.postRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/user/forget-password',
          data: {
            'email': emailController.text.trim(),
          },
        );
        if (response.statusCode == 200 && response.data != null) {
          final responseData = LoginModel.fromJson(response.data);
          if (responseData.message == ["Login successful"]) {
            Get.snackbar(
              'Forget Password',
              'Welcome ${responseData.customer.firstName} ${responseData.customer.lastName}!',
            );
            // String userToken = responseData.token;
            // String userId = responseData.user.id;
            // String userEmail = responseData.user.email;
            // String userProfileImage = responseData.user.profileImage;
            // String userName =
            //     '${responseData.user.firstName} ${responseData.user.lastName}';
            // String userPhone = responseData.user.phone;
            // await SharedPreferencesServices.setJwtToken(userToken);
            // await SharedPreferencesServices.setUserName(userName);
            // await SharedPreferencesServices.setIsLoggedIn(true);
            // await SharedPreferencesServices.setUserId(userId);
            // await SharedPreferencesServices.setUserEmail(userEmail);
            // await SharedPreferencesServices.setUserProfileImage(
            //   userProfileImage,
            // );
            // await SharedPreferencesServices.setPhoneNumber(userPhone);
            Get.offAllNamed(AppRoutes.login);
          } else {
            Get.snackbar(
              'Login Error',
              response.statusMessage ?? 'Unknown error',
            );
          }
        } else {
          Get.snackbar(
            'Login Error',
            response.statusMessage ?? 'Unknown error',
          );
        }
      } catch (e) {
        // Handle error
        Get.snackbar('Login Error', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }
}
