// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:Xkart/models/cart_models/allcarts_models.dart';
// import 'package:Xkart/services/api_services.dart';
// import 'package:Xkart/util/helpers/helper_functions.dart';
// import 'package:dio/dio.dart' as dio;

// class CartController extends GetxController {
//   final ApiServices _apiServices = ApiServices();
//   final RxBool isLoading = false.obs;
//   final RxBool isAddCartLoading = false.obs;
//   final RxBool isRemoveFromCartLoading = false.obs;
//   final RxInt itemCount = 1.obs;

//   final Rx<AllCartsModels?> carts = Rx<AllCartsModels?>(null);
//   final RxString errorMessage = ''.obs;
//   final RxBool isCartLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCarts();
//   }

//   @override
//   onClose() {
//     super.onClose();
//     itemCount.value = 1;
//   }

//   /// Fetch all carts
//   Future<void> fetchCarts() async {
//     isCartLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final dio.Response response = await _apiServices.getRequest(
//         authToken: true,
//         url:
//             'https://moment-wrap-backend.vercel.app/api/customer/get-all-carts',
//         queryParameters: {},
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         print("Cart Response Data: ${response.data}");
//         // Check if the response has the expected structure
//         if (response.data is Map<String, dynamic>) {
//           final responseData = AllCartsModels.fromJson(response.data);
//           carts.value = responseData;
//         } else if (response.data is List) {
//           // Handle case where API returns a list directly
//           carts.value = AllCartsModels(
//             success: true,
//             data: (response.data as List)
//                 .map((item) => CartItem.fromJson(item))
//                 .toList(),
//           );
//         }
//         log('${carts.toString()}');
//       } else {
//         errorMessage.value = 'Failed to load cart data';
//       }
//     } catch (e) {
//       print('Error fetching carts: $e');
//       errorMessage.value = 'Error loading cart: $e';
//     } finally {
//       isCartLoading.value = false;
//     }
//   }

//   Future<void> addToCart({
//     required String productId,
//     required String image,
//     required double totalPrice,
//     required int quantity,
//   }) async {
//     try {
//       isAddCartLoading.value = true;
//       dio.Response? response = await _apiServices.requestPostForApi(
//         authToken: true,
//         url: 'https://moment-wrap-backend.vercel.app/api/customer/add-to-cart',
//         dictParameter: {
//           'productId': productId,
//           'quantity': quantity,
//           'image': image,
//           'totalPrice': totalPrice,
//         },
//       );

//       log('${response!.data}');

//       if (response.statusCode == 200) {
//         HelperFunctions.showSnackbar(
//           message: 'Successfully added to cart',

//           title: 'Added To Cart',

//           backgroundColor: Colors.green,
//         );
//         fetchCarts(); // Refresh cart data
//       } else {
//         HelperFunctions.showSnackbar(
//           message: 'Failed to add item to cart',
//           title: 'Failed To Add Item',
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       HelperFunctions.showSnackbar(
//         message: 'An error occurred while adding to cart.',
//         title: 'Error Adding To Cart',
//         backgroundColor: Colors.red,
//       );
//       print(e);
//     } finally {
//       isAddCartLoading.value = false;
//     }
//   }

//   Future<void> removeFromCart(String cartItemId) async {
//     try {
//       isRemoveFromCartLoading.value = true;
//       final dio.Response response = await _apiServices.deleteRequest(
//         authToken: true,
//         url:
//             'https://moment-wrap-backend.vercel.app/api/customer/remove-from-cart/$cartItemId',
//       );

//       log('${response.data}');

//       if (response.statusCode == 200) {
//         HelperFunctions.showSnackbar(
//           title: 'Success',
//           message: 'Item removed successfully.',
//           backgroundColor: Colors.green,
//         );
//         fetchCarts(); // Refresh cart data
//       } else {
//         HelperFunctions.showSnackbar(
//           title: 'Error',
//           message: 'Failed to remove item from cart',
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       HelperFunctions.showSnackbar(
//         title: 'Error',
//         message: 'Failed to remove item from cart',
//         backgroundColor: Colors.red,
//       );
//       log('Error removing item from cart: $e');
//     } finally {
//       isRemoveFromCartLoading.value = false;
//     }
//   }

//   void addItems() {
//     itemCount.value++;
//   }

//   void removeItems() {
//     if (itemCount.value > 1) {
//       itemCount.value--;
//     }
//   }

//   // Calculate total cart value
//   double get totalPrice {
//     if (carts.value == null) return 0.0;

//     double total = 0.0;
//     for (var item in carts.value!.data) {
//       total += item.product.price * item.quantity;
//     }
//     return total;
//   }

//   // Get total number of items in cart
//   int get totalItems {
//     if (carts.value == null) return 0;

//     int total = 0;
//     for (var item in carts.value!.data) {
//       total += item.quantity;
//     }
//     return total;
//   }

//   // Calculate total
//   // double get total => subtotal + shippingPrice;

// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:Xkart/models/cart_models/allcarts_models.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:Xkart/util/helpers/helper_functions.dart';
import 'package:dio/dio.dart' as dio;

class CartController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final RxBool isLoading = false.obs;
  final RxBool isAddCartLoading = false.obs;
  final RxBool isRemoveFromCartLoading = false.obs;
  final RxInt itemCount = 1.obs;

  final Rx<AllCartsModels?> carts = Rx<AllCartsModels?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isCartLoading = false.obs;

  // Local quantity management - Map to store local quantities
  final RxMap<String, int> localQuantities = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarts();
  }

  @override
  onClose() {
    super.onClose();
    itemCount.value = 1;
    localQuantities.clear();
  }

  /// Fetch all carts
  Future<void> fetchCarts() async {
    isCartLoading.value = true;
    errorMessage.value = '';

    try {
      final dio.Response response = await _apiServices.getRequest(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/get-all-carts',
        queryParameters: {},
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Cart Response Data: ${response.data}");

        if (response.data is Map<String, dynamic>) {
          final responseData = AllCartsModels.fromJson(response.data);
          carts.value = responseData;
        } else if (response.data is List) {
          carts.value = AllCartsModels(
            success: true,
            data: (response.data as List)
                .map((item) => CartItem.fromJson(item))
                .toList(),
          );
        }

        // Initialize local quantities with API quantities
        _initializeLocalQuantities();

        log('${carts.toString()}');
      } else {
        errorMessage.value = 'Failed to load cart data';
      }
    } catch (e) {
      print('Error fetching carts: $e');
      errorMessage.value = 'Error loading cart: $e';
    } finally {
      isCartLoading.value = false;
    }
  }

  // Initialize local quantities with API data
  void _initializeLocalQuantities() {
    localQuantities.clear();
    if (carts.value?.data != null) {
      for (var item in carts.value!.data) {
        localQuantities[item.id] = item.quantity;
      }
    }
  }

  // Local quantity increase
  void increaseLocalQuantity(String cartItemId) {
    final currentQuantity = localQuantities[cartItemId] ?? 1;
    localQuantities[cartItemId] = currentQuantity + 1;
  }

  // Local quantity decrease
  void decreaseLocalQuantity(String cartItemId) {
    final currentQuantity = localQuantities[cartItemId] ?? 1;
    if (currentQuantity > 1) {
      localQuantities[cartItemId] = currentQuantity - 1;
    }
  }

  // Get local quantity for a cart item
  int getLocalQuantity(String cartItemId) {
    return localQuantities[cartItemId] ?? 1;
  }

  // Get final cart data for placing order (with local quantities)
  List<Map<String, dynamic>> getFinalCartData() {
    if (carts.value?.data == null) return [];

    return carts.value!.data.map((item) {
      final localQty = getLocalQuantity(item.id);
      return {
        'productId': item.product.id,
        'quantity': localQty,
        'price': item.product.price,
        'totalPrice': item.product.price * localQty,
        'image': item.product.images.isNotEmpty ? item.product.images[0] : '',
        'name': item.product.name,
      };
    }).toList();
  }

  Future<void> addToCart({
    required String productId,
    required String image,
    required double totalPrice,
    required int quantity,
  }) async {
    try {
      isAddCartLoading.value = true;
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/add-to-cart',
        dictParameter: {
          'productId': productId,
          'quantity': quantity,
          'image': image,
          'totalPrice': totalPrice,
        },
      );

      log('${response!.data}');

      if (response.statusCode == 200) {
        HelperFunctions.showSnackbar(
          message: 'Successfully added to cart',
          title: 'Added To Cart',
          backgroundColor: Colors.green,
        );
        fetchCarts(); // Refresh cart data
      } else {
        HelperFunctions.showSnackbar(
          message: 'Failed to add item to cart',
          title: 'Failed To Add Item',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        message: 'An error occurred while adding to cart.',
        title: 'Error Adding To Cart',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isAddCartLoading.value = false;
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    try {
      isRemoveFromCartLoading.value = true;
      final dio.Response response = await _apiServices.deleteRequest(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/remove-from-cart/$cartItemId',
      );

      log('${response.data}');

      if (response.statusCode == 200) {
        HelperFunctions.showSnackbar(
          title: 'Success',
          message: 'Item removed successfully.',
          backgroundColor: Colors.green,
        );
        // Remove from local quantities too
        localQuantities.remove(cartItemId);
        fetchCarts(); // Refresh cart data
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: 'Failed to remove item from cart',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: 'Failed to remove item from cart',
        backgroundColor: Colors.red,
      );
      log('Error removing item from cart: $e');
    } finally {
      isRemoveFromCartLoading.value = false;
    }
  }

  void addItems() {
    itemCount.value++;
  }

  void removeItems() {
    if (itemCount.value > 1) {
      itemCount.value--;
    }
  }

  //incrementCart
  RxBool isUpdatevLoading = false.obs;
  Future<void> incrementCart({
    required String productId,

    required int quantity,
  }) async {
    try {
      isUpdatevLoading.value = true;
      dio.Response? response = await _apiServices.requestPatchForApi(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/cart/increment/$productId',
        dictParameter: {'quantity': quantity},
      );

      log('${response!.data}');

      if (response.statusCode == 200) {
        HelperFunctions.showSnackbar(
          message: 'Successfully added to cart',
          title: 'Added To Cart',
          backgroundColor: Colors.green,
        );
        fetchCarts(); // Refresh cart data
      } else {
        HelperFunctions.showSnackbar(
          message: 'Failed to add item to cart',
          title: 'Failed To Add Item',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        message: 'An error occurred while adding to cart.',
        title: 'Error Adding To Cart',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isUpdatevLoading.value = false;
    }
  }

  //decrementCart
  Future<void> decrementCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      isUpdatevLoading.value = true;
      dio.Response? response = await _apiServices.requestPatchForApi(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/cart/decrement/$productId',
        dictParameter: {'quantity': quantity},
      );

      log('${response!.data}');

      if (response.statusCode == 200) {
        HelperFunctions.showSnackbar(
          message: 'Successfully added to cart',
          title: 'Added To Cart',
          backgroundColor: Colors.green,
        );
        fetchCarts(); // Refresh cart data
      } else {
        HelperFunctions.showSnackbar(
          message: 'Failed to add item to cart',
          title: 'Failed To Add Item',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        message: 'An error occurred while adding to cart.',
        title: 'Error Adding To Cart',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isUpdatevLoading.value = false;
    }
  }

  // Calculate total cart value using local quantities
  double get totalPrice {
    if (carts.value == null) return 0.0;

    double total = 0.0;
    for (var item in carts.value!.data) {
      final localQty = getLocalQuantity(item.id);
      total += item.product.price * localQty;
    }
    return total;
  }

  // Get total number of items in cart using local quantities
  int get totalItems {
    if (carts.value == null) return 0;

    int total = 0;
    for (var item in carts.value!.data) {
      final localQty = getLocalQuantity(item.id);
      total += localQty;
    }
    return total;
  }
}
