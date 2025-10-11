import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Xkart/view/profile_screen/profile_models/customer_profile_model.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/services/shared_preferences_services.dart';
import 'package:Xkart/services/api_services.dart';

class ProfileController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  // Profile data using model
  Rxn<CustomerProfile> profile = Rxn<CustomerProfile>();
  var profileImage = Rxn<File>();

  // Convenience getters for UI binding
  String get firstName => profile.value?.firstName ?? '';
  String get lastName => profile.value?.lastName ?? '';
  String get fullName => profile.value?.fullName ?? '';
  String get email => profile.value?.email ?? '';
  String get phoneNumber => profile.value?.phone ?? '';
  String get userId => profile.value?.id ?? '';
  String get customerId => profile.value?.customerId ?? '';
  String get profileImageUrl => profile.value?.profileImage ?? '';
  String? get gender => profile.value?.gender;
  String? get dateOfBirth => profile.value?.dateOfBirth;
  bool get isVerified => profile.value?.isVerified ?? false;
  bool get isActive => profile.value?.isActive ?? true;
  int get cartItemsCount => profile.value?.cart.length ?? 0;
  int get wishlistCount => profile.value?.wishlist.length ?? 0;
  int get orderHistoryCount => profile.value?.orderHistory.length ?? 0;
  DateTime? get lastLogin => profile.value?.lastLogin;
  DateTime? get createdAt => profile.value?.createdAt;
  DateTime? get updatedAt => profile.value?.updatedAt;
  List<Address> get addresses => profile.value?.addresses ?? [];

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isDeleting = false.obs;

  final ImagePicker _picker = ImagePicker();

  // API endpoints
  static const String _baseUrl =
      'https://moment-wrap-backend.vercel.app/api/customer';
  static const String _getProfileEndpoint = '$_baseUrl/get-customer-profile';
  static const String _updateProfileEndpoint =
      '$_baseUrl/update-customer-profile';
  static const String _deleteProfileEndpoint =
      '$_baseUrl/delete-customer-profile';

  @override
  void onInit() {
    super.onInit();
    checkLoginAndFetchData();
  }
  // Removed erroneous isLoggedIn method; use SharedPreferencesServices.getIsLoggedIn() directly.

  Future<void> checkLoginAndFetchData() async {
    final isLoggedIn = await SharedPreferencesServices.getIsLoggedIn();
    final isAddress = await SharedPreferencesServices.hasAddresses();
    final showAddresses = await SharedPreferencesServices.getAddresses();
    print('Is user logged in? $isLoggedIn');
    print('Is user isAddress in? $isAddress');
    print('Is user showAddresses in? $showAddresses');
    if (isLoggedIn == true) {
      await getCustomerProfile();
      await fetchUserDataFromLocal();
    } else {
      debugPrint("User not logged in, skipping profile fetch.");
    }
  }

  // Get profile from API
  Future<void> getCustomerProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiServices.getRequest(
        url: _getProfileEndpoint,
        authToken: true,
      );

      print('API Response: ${response.data}');

      if (response.data != null) {
        // Handle the direct profile response
        if (response.data.containsKey('_id')) {
          profile.value = CustomerProfile.fromJson(response.data);

          // Update local storage
          await _updateLocalStorage(profile.value!);

          print('Profile data loaded successfully');
          print('Full Name: ${profile.value!.fullName}');
          print('Customer ID: ${profile.value!.customerId}');
          print('Cart Items: ${profile.value!.cart.length}');
          print('Is Verified: ${profile.value!.isVerified}');
          print('Gender: ${profile.value!.gender}');
          print('Date of Birth: ${profile.value!.dateOfBirth}');

          _showSuccess('Profile data loaded successfully');
        } else {
          print('Invalid response structure');
          _showError('Invalid response from server');
        }
      } else {
        print('Response data is null');
        _showError('No data received from server');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      _showError('Something went wrong: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile API - Fixed to match the API documentation exactly
  Future<void> updateCustomerProfile({
    required String newFirstName,
    required String newLastName,
    required String newPhone,
    String? profileImageUrl,
    String? gender,
    String? dateOfBirth,
    List<Map<String, dynamic>>? addresses,
  }) async {
    try {
      isUpdating.value = true;

      // Prepare the request body according to API documentation
      Map<String, dynamic> requestData = {
        'firstName': newFirstName,
        'lastName': newLastName,
        'phone': newPhone,
      };

      // Add optional fields if provided
      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        requestData['profileImage'] = profileImageUrl;
      }

      if (gender != null && gender.isNotEmpty) {
        requestData['gender'] = gender;
      }

      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        requestData['dateOfBirth'] = dateOfBirth;
      }

      if (addresses != null && addresses.isNotEmpty) {
        requestData['addresses'] = addresses;
      }

      print('Update request data: $requestData');

      final response = await _apiServices.putRequest(
        url: _updateProfileEndpoint,
        data: requestData,
        authToken: true,
      );

      print('Update Response: ${response.data}');

      if (response.data != null) {
        // Check if the response indicates success
        bool isSuccess = false;
        String? message;
        CustomerProfile? updatedProfile;

        if (response.data.containsKey('success')) {
          // Response has success wrapper
          isSuccess = response.data['success'] == true;
          message = response.data['message'];

          if (response.data.containsKey('data') &&
              response.data['data'] != null) {
            updatedProfile = CustomerProfile.fromJson(response.data['data']);
          }
        } else if (response.data.containsKey('_id')) {
          // Direct profile data response (assuming success if profile returned)
          isSuccess = true;
          message = 'Profile updated successfully';
          updatedProfile = CustomerProfile.fromJson(response.data);
        }

        if (isSuccess && updatedProfile != null) {
          // Update the profile data
          profile.value = updatedProfile;

          // Update local storage
          await _updateLocalStorage(updatedProfile);

          _showSuccess(message ?? 'Profile updated successfully');

          // Refresh the profile data to ensure consistency
          await getCustomerProfile();

          Get.back(); // Go back to profile screen
        } else {
          _showError(message ?? 'Failed to update profile');
        }
      } else {
        _showError('Invalid response from server');
      }
    } catch (e) {
      print('Error updating profile: $e');
      _showError(
        'Something went wrong while updating profile: ${e.toString()}',
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
        url: _deleteProfileEndpoint,
        authToken: true,
      );

      print('Delete Response: ${response.data}');

      if (response.data != null) {
        bool isSuccess = false;
        String? message;

        if (response.data.containsKey('success')) {
          isSuccess = response.data['success'] == true;
          message = response.data['message'];
        } else if (response.statusCode == 200) {
          // Assume success if status code is 200
          isSuccess = true;
          message = 'Account deleted successfully';
        }

        if (isSuccess) {
          _showSuccess(message ?? 'Account deleted successfully');

          // Clear all data and redirect to login
          await SharedPreferencesServices.clearAll();
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          _showError(message ?? 'Failed to delete account');
        }
      } else {
        _showError('Invalid response from server');
      }
    } catch (e) {
      print('Error deleting profile: $e');
      _showError(
        'Something went wrong while deleting account: ${e.toString()}',
      );
    } finally {
      isDeleting.value = false;
    }
  }

  // Image picker methods
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        // TODO: Implement image upload to server if you have an endpoint for it
        // For now, just store locally - you'll need to handle image upload separately
        _showSuccess('Profile image selected');
      }
    } catch (e) {
      print("Error picking image: $e");
      _showError("Error picking image: ${e.toString()}");
    }
  }

  void removeImage() {
    profileImage.value = null;
    // Also clear the profile image URL if updating profile
    if (profile.value != null) {
      profile.value = profile.value!.copyWith(profileImage: '');
    }
    _showSuccess('Profile image removed');
  }

  // Future image upload method (implement when API is ready)
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      // TODO: Implement image upload to your API
      // This would typically involve multipart/form-data upload
      // Return the uploaded image URL
      print('Image upload not implemented yet');
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      _showError('Failed to upload profile image');
      return null;
    }
  }

  // Authentication methods
  void logOut() async {
    try {
      await SharedPreferencesServices.clearAll();
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      print('Error during logout: $e');
      _showError('Error during logout');
    }
  }

  // Local data methods - Enhanced
  Future<void> fetchUserDataFromLocal() async {
    try {
      final localFirstName =
          await SharedPreferencesServices.getUserName() ?? '';
      final localEmail = await SharedPreferencesServices.getUserEmail() ?? '';
      final localPhone = await SharedPreferencesServices.getPhoneNumber() ?? '';

      // Create temporary profile from local data if available
      if (localFirstName.isNotEmpty || localEmail.isNotEmpty) {
        final nameParts = localFirstName.split(' ');
        profile.value = CustomerProfile(
          id: '',
          firstName: nameParts.isNotEmpty ? nameParts.first : '',
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          email: localEmail,
          phone: localPhone,
          role: 'customer',
        );
        print('Loaded local profile data for: ${profile.value!.fullName}');
      }
    } catch (e) {
      print('Error fetching local user data: $e');
    }
  }

  Future<void> _updateLocalStorage(CustomerProfile profile) async {
    try {
      List<Map<String, dynamic>> addresses = (profile.addresses as List)
          .cast<Map<String, dynamic>>();
      await SharedPreferencesServices.setUserName(profile.fullName);
      await SharedPreferencesServices.setIsLoggedIn(true);
      await SharedPreferencesServices.setUserId(profile.id);
      await SharedPreferencesServices.setUserEmail(profile.email);
      await SharedPreferencesServices.setUserProfileImage(profile.profileImage);
      await SharedPreferencesServices.setUserId(profile.customerId);
      await SharedPreferencesServices.saveAddresses(addresses);
      await SharedPreferencesServices.setPhoneNumber(profile.phone);
      print('Updated local storage with latest profile data');
    } catch (e) {
      print('Error updating local storage: $e');
    }
  }

  // Show delete confirmation dialog
  void showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and will remove all your data including orders, cart items, and wishlist.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => TextButton(
              onPressed: isDeleting.value
                  ? null
                  : () {
                      Get.back();
                      deleteCustomerProfile();
                    },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: isDeleting.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await getCustomerProfile();
  }

  // Helper methods for showing messages
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Enhanced validation methods
  bool validateUpdateData({
    required String firstName,
    required String lastName,
    required String phone,
  }) {
    if (firstName.trim().isEmpty) {
      _showError('First name is required');
      return false;
    }

    if (firstName.trim().length < 2) {
      _showError('First name must be at least 2 characters long');
      return false;
    }

    if (lastName.trim().isEmpty) {
      _showError('Last name is required');
      return false;
    }

    if (lastName.trim().length < 2) {
      _showError('Last name must be at least 2 characters long');
      return false;
    }

    if (phone.trim().isEmpty) {
      _showError('Phone number is required');
      return false;
    }

    // Enhanced phone validation - Handle +91- prefix
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.startsWith('91') && cleanPhone.length == 12) {
      cleanPhone = cleanPhone.substring(2); // Remove country code
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(cleanPhone)) {
      _showError('Please enter a valid 10-digit phone number');
      return false;
    }

    return true;
  }

  // Check if profile data has changed
  bool hasProfileChanged({
    required String firstName,
    required String lastName,
    required String phone,
    String? gender,
    String? dateOfBirth,
    List<Map<String, dynamic>>? addresses,
  }) {
    return profile.value?.firstName != firstName.trim() ||
        profile.value?.lastName != lastName.trim() ||
        profile.value?.phone != phone.trim() ||
        profile.value?.gender != gender ||
        profile.value?.dateOfBirth != dateOfBirth ||
        _hasAddressChanged(addresses);
  }

  bool _hasAddressChanged(List<Map<String, dynamic>>? newAddresses) {
    if (newAddresses == null || newAddresses.isEmpty) {
      return addresses.isNotEmpty;
    }

    if (addresses.isEmpty) {
      return true;
    }

    final currentAddress = addresses.first;
    final newAddress = newAddresses.first;

    return currentAddress.street != newAddress['street'] ||
        currentAddress.city != newAddress['city'] ||
        currentAddress.state != newAddress['state'] ||
        currentAddress.zipCode != newAddress['postalCode'] ||
        currentAddress.country != newAddress['country'];
  }

  // Get profile summary for debugging
  Map<String, dynamic> getProfileSummary() {
    if (profile.value == null) return {'status': 'No profile data'};

    return {
      'id': profile.value!.id,
      'customerId': profile.value!.customerId,
      'fullName': profile.value!.fullName,
      'email': profile.value!.email,
      'phone': profile.value!.phone,
      'gender': profile.value!.gender,
      'dateOfBirth': profile.value!.dateOfBirth,
      'isActive': profile.value!.isActive,
      'isVerified': profile.value!.isVerified,
      'cartItems': profile.value!.cart.length,
      'wishlistItems': profile.value!.wishlist.length,
      'orderHistory': profile.value!.orderHistory.length,
      'addressCount': profile.value!.addresses.length,
      'lastLogin': profile.value!.lastLogin?.toString() ?? 'Never',
      'createdAt': profile.value!.createdAt?.toString() ?? 'Unknown',
    };
  }

  RxBool isLoggedIn = false.obs;
  Future<bool> isologin() async {
    isLoggedIn.value = await SharedPreferencesServices.getIsLoggedIn();
    return isLoggedIn.value;
  }
}
