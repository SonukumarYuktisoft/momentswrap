import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/controllers/profile_controller/profile_controller.dart';


class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<OrderController>(OrderController(), permanent: true);
  }
}
