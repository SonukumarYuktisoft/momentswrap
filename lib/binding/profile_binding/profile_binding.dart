import 'package:get/get.dart';
import 'package:Xkart/view/profile_screen/profile_controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
