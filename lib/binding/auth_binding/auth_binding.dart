import 'package:get/get.dart';
import 'package:Xkart/view/auth/controllers/forget_controller.dart';
import 'package:Xkart/view/auth/controllers/login_controller.dart';
import 'package:Xkart/view/auth/controllers/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<SignupController>(SignupController(), permanent: true);
    Get.put<ForgetController>(ForgetController(), permanent: true);
  }
}
