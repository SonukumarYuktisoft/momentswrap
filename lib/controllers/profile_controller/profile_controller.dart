// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:momentswrap/routes/app_routes.dart';
// import 'package:momentswrap/services/shared_preferences_services.dart';

// class ProfileController extends GetxController {
//   var profileImage = Rxn<File>(); // Stores selected image file

//     RxString fullName = ''.obs;
//   RxString email = ''.obs;
//   RxString phoneNumber = ''.obs;

//   final ImagePicker _picker = ImagePicker();

//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         profileImage.value = File(pickedFile.path);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   void removeImage() {
//     profileImage.value = null;
//   }

//   void logOut() async {
//     // Implement your logout logic here
//     await SharedPreferencesServices.clearAll();
//     Get.offAllNamed(AppRoutes.login);
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch user data from shared preferences and update the variables
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     fullName.value = (await SharedPreferencesServices.getUserName()) ?? '';
//     email.value = (await SharedPreferencesServices.getUserEmail()) ?? '';
//     phoneNumber.value = (await SharedPreferencesServices.getPhoneNumber()) ?? '';

//   }

// }

// 1. Updated Profile Controller with API Integration
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/services/shared_preferences_services.dart';
import 'package:momentswrap/services/api_services.dart';

class ProfileController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  var profileImage = Rxn<File>();
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString userId = ''.obs;

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isDeleting = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    getCustomerProfile();
  }

  // Get profile from API

  // Get profile from API
  Future<void> getCustomerProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiServices.getRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/get-customer-profile',
        authToken: true,
      );

      print('API Response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      // Check if response and response.data are not null
      if (response.data != null && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == 200 && responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;

          userId.value = data['_id']?.toString() ?? '';
          firstName.value = data['firstName']?.toString() ?? '';
          lastName.value = data['lastName']?.toString() ?? '';
          fullName.value = '${firstName.value} ${lastName.value}'.trim();
          email.value = data['email']?.toString() ?? '';
          phoneNumber.value = data['phone']?.toString() ?? '';

          // Update local storage
          // await SharedPreferencesServices.saveUserName(fullName.value);
          // await SharedPreferencesServices.saveUserEmail(email.value);
          // await SharedPreferencesServices.savePhoneNumber(phoneNumber.value);

          print('Profile data loaded successfully');
        } else {
          print('API returned success=false or data is null');
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to fetch profile data',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Response data is null or not a Map');
        Get.snackbar(
          'Error',
          'Invalid response from server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching profile: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile API
  Future<void> updateCustomerProfile({
    required String newFirstName,
    required String newLastName,
    required String newPhone,
  }) async {
    try {
      isUpdating.value = true;

      final Map<String, dynamic> requestData = {
        "firstName": newFirstName,
        "lastName": newLastName,
        "phone": newPhone,
      };

      final response = await _apiServices.putRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/update-customer-profile',
        data: requestData,
        authToken: true,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];

        firstName.value = data['firstName'] ?? '';
        lastName.value = data['lastName'] ?? '';
        fullName.value = '${firstName.value} ${lastName.value}'.trim();
        phoneNumber.value = data['phone'] ?? '';

        // // Update local storage
        // await SharedPreferencesServices.saveUserName(fullName.value);
        // await SharedPreferencesServices.savePhoneNumber(phoneNumber.value);

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back(); // Go back to profile screen
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete profile API
  Future<void> deleteCustomerProfile() async {
    try {
      isDeleting.value = true;

      final response = await _apiServices.deleteRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/delete-customer-profile',
        authToken: true,
      );

      if (response.data['success'] == true) {
        Get.snackbar(
          'Success',
          'Account deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear all data and redirect to login
        await SharedPreferencesServices.clearAll();
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to delete account',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error deleting profile: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void removeImage() {
    profileImage.value = null;
  }

  void logOut() async {
    await SharedPreferencesServices.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> fetchUserData() async {
    fullName.value = (await SharedPreferencesServices.getUserName()) ?? '';
    email.value = (await SharedPreferencesServices.getUserEmail()) ?? '';
    phoneNumber.value =
        (await SharedPreferencesServices.getPhoneNumber()) ?? '';
  }

  // Show delete confirmation dialog
  void showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteCustomerProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
