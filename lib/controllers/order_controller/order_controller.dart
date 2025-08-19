import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:momentswrap/services/api_services.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:dio/dio.dart' as dio;

class OrderController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> placeOrder(
    {
      required String user,
      required double  totalPrice, 
      required String  shippingAddress, 
      required String  paymentMethod, 
      required List  items, 
    }
  ) async {
    try {
  isLoading.value = true;
      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moments-wrap-backend.vercel.app/order/addOrder',
        dictParameter: {
          'user': user,
          'totalPrice': totalPrice.toString(),
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
          'items': items,
        },
      );

      if (response != null && response.statusCode == 200) {


           HelperFunctions.showSnackbar(
          'Success',
          ' Place Order',
          title: 'Success',
          message: 'Place Order Successfull',
          backgroundColor: Colors.green,
        );
      } 
  

      
    } catch (e) {

 HelperFunctions.showSnackbar(
        'Error',
        'Failed to Order',
        title: 'Error',
        message: 'Failed to Order',
        backgroundColor: Colors.red,
      );
 print(e);

    } finally {
      isLoading.value = true;
    }
  }
}
