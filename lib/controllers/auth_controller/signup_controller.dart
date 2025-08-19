import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:momentswrap/models/auth_model/login_model.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:momentswrap/services/shared_preferences_services.dart';

class SignupController extends GetxController {
  // Define your signup-related methods and properties here
  ApiServices _apiServices = ApiServices();
  RxBool isLoading = false.obs;
  RxBool toggle = true.obs;

  /// Toggles the password visibility
  void changeToggle() {
    toggle.value = !toggle.value;
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  Future<void> signup() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        dio.Response response = await _apiServices.postRequest(
          authToken: false,
          url: 'https://moments-wrap-backend.vercel.app/user/register',
          data: {
            'firstName': firstNameController.text.trim(),
            'lastName': lastNameController.text.trim(),
            'phone': phoneController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          },
        );
        if (response.statusCode == 200 && response.data != null) {
          final responseData = LoginModel.fromJson(response.data);
          if (responseData.success == true) {
            Get.snackbar(
              'Login Success',
              'Welcome ${responseData.user.firstName} ${responseData.user.lastName}!',
            );
            String userToken = responseData.token;
            String userId = responseData.user.id;
            String userEmail = responseData.user.email;
            String userProfileImage = responseData.user.profileImage;
            String userName =
                '${responseData.user.firstName} ${responseData.user.lastName}';
            String userPhone = responseData.user.phone;
            await SharedPreferencesServices.setJwtToken(userToken);
            await SharedPreferencesServices.setUserName(userName);
            await SharedPreferencesServices.setIsLoggedIn(true);
            await SharedPreferencesServices.setUserId(userId);
            await SharedPreferencesServices.setUserEmail(userEmail);
            await SharedPreferencesServices.setUserProfileImage(
              userProfileImage,
            );
            await SharedPreferencesServices.setPhoneNumber(userPhone);
            Get.offAllNamed(AppRoutes.bottomNavigation);
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
