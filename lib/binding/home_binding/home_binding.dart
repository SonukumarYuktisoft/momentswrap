import 'package:get/get.dart';
import 'package:Xkart/controllers/location_controller/location_controller.dart';
import 'package:Xkart/controllers/product_controller/product_controller.dart';
import 'package:Xkart/view/search_screens/search_controller/search_product_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController(), permanent: true);
    Get.put(ProductController(), permanent: true);
  }
}
