import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/order_model/order_model.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:momentswrap/services/app_config.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';

class OrderController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final AppConfig _appConfig = AppConfig();

  final CartController cartController = Get.put(CartController());

  final RxBool isLoading = false.obs;
  final RxBool isBuyProductLoading = false.obs;

  final RxList<OrderModel> myOrders = <OrderModel>[].obs;
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  Future<void> buyProduct({
    required String productId,
    required int quantity,
  }) async {
    try {
      isBuyProductLoading.value = true;

      final Map<String, dynamic> requestBody = {
        "productId": productId,
        "quantity": quantity,
      };

      dio.Response? response = await _apiServices.requestPostForApi(
        authToken: true,
        url: '$_appConfig/api/customer/buy-product',
        dictParameter: requestBody,
      );

      if (response != null && response.statusCode == 201) {
        final data = response.data;

        HelperFunctions.showSnackbar(
          title: 'Success',
          message: data['message'] ?? 'Order placed successfully',
          backgroundColor: Colors.green,
        );

        // Refresh orders after successful purchase
        await fetchMyOrders();
        cartController.itemCount.value -= quantity;
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: 'Unexpected response from server',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      print('Buy product error: $e');
    } finally {
      isBuyProductLoading.value = false;
    }
  }

  // Alternative bulk order method if API supports it
  Future<void> buyProductsBulk(List<Map<String, dynamic>> productsToBuy) async {
    try {
      // This would be for a bulk order API endpoint
      final response = await _apiServices.requestPostonlyOrdersApi(
        authToken: true,
        url: '$_appConfig/api/customer/buy-product',
        dictParameter: productsToBuy, // Send array directly
      );

      if (response != null && response.statusCode == 201) {
        final data = response.data;

        HelperFunctions.showSnackbar(
          title: 'Success',
          message: data['message'] ?? 'Orders placed successfully',
          backgroundColor: Colors.green,
        );

        // Refresh orders
        await fetchMyOrders();
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: '',
          backgroundColor: Colors.red,
        );
        throw Exception('Unexpected response from server');
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      print('Bulk order error: $e');
      rethrow;
    }
  }

  Future<void> fetchMyOrders() async {
    try {
      isLoading.value = true;

      dio.Response? response = await _apiServices.getRequest(
        authToken: true,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/list-my-orders',
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        print('API Response: ${data.toString()}');

        // The API returns a direct array, not wrapped in a data object
        if (data is List) {
          final List<dynamic> ordersJson = data;
          final List<OrderModel> parsedOrders = [];

          for (var orderJson in ordersJson) {
            try {
              if (orderJson is Map<String, dynamic>) {
                final order = OrderModel.fromJson(orderJson);
                parsedOrders.add(order);
              }
            } catch (e, stackTrace) {
              print('Error parsing individual order: $e');
              print('Stack trace: $stackTrace');
              print('Order JSON: $orderJson');
            }
          }

          // Sort latest orders first
          parsedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          myOrders.value = parsedOrders;
          print('Successfully parsed ${parsedOrders.length} orders');
        } else if (data is Map<String, dynamic> &&
            data['success'] == true &&
            data['data'] is List) {
          // Fallback for wrapped response format
          final List<dynamic> ordersJson = data['data'];
          final List<OrderModel> parsedOrders = [];

          for (var orderJson in ordersJson) {
            try {
              if (orderJson is Map<String, dynamic>) {
                final order = OrderModel.fromJson(orderJson);
                parsedOrders.add(order);
              }
            } catch (e, stackTrace) {
              print('Error parsing individual order: $e');
              print('Stack trace: $stackTrace');
              print('Order JSON: $orderJson');
            }
          }

          // Sort latest orders first
          parsedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          myOrders.value = parsedOrders;
          print('Successfully parsed ${parsedOrders.length} orders');
        }
      }
    } catch (e, stackTrace) {
      print('Fetch orders error: $e');
      print('Stack trace: $stackTrace');
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: 'Could not load your orders',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderDetails(String orderId) async {
    try {
      isLoading.value = true;

      dio.Response? response = await _apiServices.getRequest(
        authToken: true,
        url: '$_appConfig/api/customer/get-order-details/$orderId',
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        // Handle both direct order response and wrapped response
        if (data is Map<String, dynamic>) {
          if (data['success'] == true && data['data'] != null) {
            selectedOrder.value = OrderModel.fromJson(data['data']);
          } else if (data['_id'] != null) {
            // Direct order object response
            selectedOrder.value = OrderModel.fromJson(data);
          } else {
            HelperFunctions.showSnackbar(
              title: 'Error',
              message: data['message'] ?? 'Order not found',
              backgroundColor: Colors.red,
            );
          }
        }
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: 'Unexpected response from server',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      print('Get order details error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder({required String orderId, dynamic reason}) async {
    try {
      isLoading.value = true;

      final url =
          'https://moment-wrap-backend.vercel.app/api/customer/cancel-order/$orderId';

      dio.Response? response = await _apiServices.requestPutForApi(
        authToken: true,
        url: url,
        dictParameter: {"reason": reason},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          HelperFunctions.showSnackbar(
            title: 'Success',
            message: data['message'] ?? 'Order cancelled successfully',
            backgroundColor: Colors.green,
          );

          // Update the order status locally
          final orderIndex = myOrders.indexWhere(
            (order) => order.id == orderId,
          );
          if (orderIndex != -1) {
            final updatedOrder = myOrders[orderIndex].copyWith(
              orderStatus: 'cancelled',
              updatedAt: DateTime.now(),
            );
            myOrders[orderIndex] = updatedOrder;
          }

          // Update selected order if it's the same
          if (selectedOrder.value?.id == orderId) {
            selectedOrder.value = selectedOrder.value!.copyWith(
              orderStatus: 'cancelled',
              updatedAt: DateTime.now(),
            );
          }
        } else {
          HelperFunctions.showSnackbar(
            title: 'Error',
            message: data['message'] ?? 'Something went wrong',
            backgroundColor: Colors.red,
          );
        }
      } else {
        HelperFunctions.showSnackbar(
          title: 'Error',
          message: 'Unexpected response from server',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
      print('Cancel order error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods for UI
  String getFormattedOrderId(String orderId) {
    return orderId.length >= 8
        ? orderId.substring(orderId.length - 8)
        : orderId;
  }

  String getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String getFormattedDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void clearSelectedOrder() {
    selectedOrder.value = null;
  }

  int getTotalQuantity(OrderModel order) {
    return order.products.fold(0, (sum, product) => sum + product.quantity);
  }

  OrderProduct? getMainProduct(OrderModel order) {
    return order.products.isNotEmpty ? order.products.first : null;
  }
}
