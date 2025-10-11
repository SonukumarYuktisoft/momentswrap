import 'package:get/get.dart';
import 'package:Xkart/view/add_to_cart_screen/controller/cart_controller.dart';
import 'package:Xkart/view/order_screen/controller/order_controller.dart';
import 'package:Xkart/view/profile_screen/profile_controller/profile_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<OrderController>(OrderController(), permanent: true);
  }
}
