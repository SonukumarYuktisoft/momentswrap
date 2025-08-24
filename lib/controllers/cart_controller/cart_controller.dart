import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:momentswrap/models/cart_models/allcarts_models.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchCarts();
  }
  
  @override
  onClose() {
    super.onClose();
    itemCount.value = 1;
  }

  ///fatch all carts

  Future<void> fetchCarts() async {
    isCartLoading.value = true;
    errorMessage.value = '';

    try {
      final dio.Response response = await _apiServices.getRequest(
        authToken: true, // Assuming carts require authentication
        url: 'https://moments-wrap-backend.vercel.app/cart/getAllCarts',
        queryParameters: {},
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Cart Response Data: ${response.data}");
        final responseData = AllCartsModels.fromJson(response.data);
        carts.value = responseData;
        log('${carts.toString()}');
        isCartLoading.value = false;
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

  Future<void> addToCart({
    required String productId,
    required int quantity,
    required double totalPrice,
    required String image,
  }) async {
    try {
      isAddCartLoading.value = true;
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/add-to-cart',
        dictParameter: {
          'productId': productId,
          'quantity': quantity,
          'price': totalPrice, // Changed from 'totalPrice' to 'price'
          'image': image,
        },
      );

      log('${response!.data}');

      if (response.statusCode == 201) {
        // The API returns the updated cart items, not a message
        HelperFunctions.showSnackbar(
          'Success',
          'Item added to cart',
          title: 'Success',
          message: 'Item added to cart successfully', // Use a fixed message
          backgroundColor: Colors.green,
        );

        // fetchCarts(); // Refresh cart data
        itemCount.value -= quantity;
      } else {
        // Handle other status codes
        HelperFunctions.showSnackbar(
          'Error',
          'Failed to add item to cart',
          title: 'Error',
          message: 'Unexpected response from server',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        'Error',
        'Failed to add item to cart',
        title: 'Error',
        message: 'Network error occurred',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isAddCartLoading.value = false;
    }
  }

  //  int get totalQuantity =>
  Future<void> removeFromCart(String productId) async {
    try {
      isRemoveFromCartLoading.value = true;
      final dio.Response response = await _apiServices.deleteRequest(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/remove-from-cart/$productId',
      );
      log('${response.data}');
      if (response.statusCode == 200) {
        HelperFunctions.showSnackbar(
          'Success',
          'Item removed from cart',
          title: 'Success',
          message: response.data['message'] ?? 'Item removed from cart',
          backgroundColor: Colors.green,
        );
        // fetchCarts(); // Refresh cart data
      } else {
        HelperFunctions.showSnackbar(
          'Error',
          'Failed to remove item from cart',
          title: 'Error',
          message:
              response.data['message'] ?? 'Failed to remove item from cart',
          backgroundColor: Colors.red,
        );
      }
      log('Item removed from cart: ${response.data}');
    } catch (e) {
      HelperFunctions.showSnackbar(
        'Error',
        'Failed to remove item from cart',
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
    if (itemCount.value > 0) {
      itemCount.value--;
    }
  }

  ///
}
