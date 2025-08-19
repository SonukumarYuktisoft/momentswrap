import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:momentswrap/models/cart_models/addto_cart_model.dart';
import 'package:momentswrap/models/cart_models/cart_models.dart';
import 'package:momentswrap/models/cart_models/get_all_cart_model.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:dio/dio.dart' as dio;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CartController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final RxList<Product> cartItems = <Product>[].obs;
  final RxList<AddToCartModel> addToCartModel = <AddToCartModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt itemCount = 1.obs;

  

  Future<void> addToCart({
    required String productId,
    required int quantity,
    required String image,
    required double price,
  }) async {
    try {
      isLoading.value = true;
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moments-wrap-backend.vercel.app/cart/addToCart',
        dictParameter: {
          'productId': productId,
          'quantity': quantity,
          'image': image,
          'price': price,
        },
      );
      log('${response!.data}');
      if (response.statusCode == 201) {
        final responseData = AddToCartModel.fromJson(response.data);

        // itemCount.value = responseData.data?.quantity ?? 1;
        // addToCartModel;

        log(itemCount.toString());

        HelperFunctions.showSnackbar(
          'Success',
          'Item added to cart',
          title: 'Success',
          message: 'Item added to cart',
          backgroundColor: Colors.green,
        );
      }
      print('Item added to cart: ${response.data}');
    } catch (e) {
      HelperFunctions.showSnackbar(
        'Error',
        'Failed to add item to cart',
        title: 'Error',
        message: 'Failed to add item to cart',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
  //  int get totalQuantity =>

  Future<void> removeFromCart(String productId) async {
    try {
      isLoading.value = true;
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moments-wrap-backend.vercel.app/cart/removeCart',
        dictParameter: {
          'productId': productId,
        },
      );
      log('${response!.data}');
      if (response.statusCode == 200) {
        

        log(itemCount.toString());

        HelperFunctions.showSnackbar(
          'Success',
          'Item remove to cart',
          title: 'Success',
          message: 'Item added to cart',
          backgroundColor: Colors.green,
        );
      }
      print('Item added to cart: ${response.data}');
    } catch (e) {
      HelperFunctions.showSnackbar(
        'Error',
        'Failed to remove item to cart',
        title: 'Error',
        message: 'Failed to add item to cart',
        backgroundColor: Colors.red,
      );
      print(e);
    } finally {
      isLoading.value = false;
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
  /// 
  Future<void> fetchGetAllCartItems() async {
    isLoading.value = true;
    try {
      // if (inStockOnly.value) {
      //   queryParameters['inStock'] = true;
      // }

      final dio.Response response = await _apiServices.getRequest(
        authToken: true,
        url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
        // queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Response Data: ${response.data}");
        final responseData = GetAllCartModel.fromJson(response.data);

       

      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }


}


