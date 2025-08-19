import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/services/shared_preferences_services.dart';

class ProfileController extends GetxController {
  var profileImage = Rxn<File>(); // Stores selected image file

    RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  

  final ImagePicker _picker = ImagePicker();

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
    // Implement your logout logic here
    await SharedPreferencesServices.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }



  @override
  void onInit() {
    super.onInit();
    // Fetch user data from shared preferences and update the variables
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    fullName.value = (await SharedPreferencesServices.getUserName()) ?? '';
    email.value = (await SharedPreferencesServices.getUserEmail()) ?? '';
    phoneNumber.value = (await SharedPreferencesServices.getPhoneNumber()) ?? '';
 
  }
}
