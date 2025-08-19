import 'package:get/get.dart';
import 'package:momentswrap/controllers/auth_controller/forget_controller.dart';
import 'package:momentswrap/controllers/auth_controller/login_controller.dart';
import 'package:momentswrap/controllers/auth_controller/signup_controller.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<SignupController>(SignupController(), permanent: true);
    Get.put<ForgetController>(ForgetController(), permanent: true);
  }
}
