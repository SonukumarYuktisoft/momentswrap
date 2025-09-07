import 'package:get/get.dart';
import 'package:momentswrap/controllers/location_controller/location_controller.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
import 'package:momentswrap/controllers/search_controller/search_product_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController(), permanent: true);
    Get.put(ProductController(), permanent: true);
  }
}
