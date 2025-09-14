import 'package:get/get.dart';
import 'package:Xkart/controllers/profile_controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
