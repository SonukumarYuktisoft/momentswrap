// Enhanced Order Controller with Place Order functionality for both Cart and Single Product
// Add these methods to your existing OrderController class

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Xkart/controllers/cart_controller/cart_controller.dart';
import 'package:Xkart/controllers/location_controller/location_controller.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:Xkart/services/shared_preferences_services.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/util/helpers/helper_functions.dart';

class PlaceOrderController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final CartController cartController = Get.put(CartController());
  final LocationController locationController = Get.put(LocationController());

  // Observable variables
  final RxBool isPlacingOrder = false.obs;
  final RxBool isBuyProductLoading = false.obs; // For single product buy now
  final RxInt currentStep = 0.obs;
  final RxString selectedAddressType = ''.obs;
  final RxString selectedPaymentMethod = 'card'.obs;
  final Rx<Map<String, dynamic>?> selectedAddress = Rx<Map<String, dynamic>?>(
    null,
  );
  final RxList<Map<String, dynamic>> profileAddresses =
      <Map<String, dynamic>>[].obs;

  // Order type tracking
  final RxString orderType = 'cart'.obs; // 'cart' or 'single'
  final Rx<Map<String, dynamic>?> singleProductData = Rx<Map<String, dynamic>?>(
    null,
  );

  // Step constants
  static const int STEP_ADDRESS = 0;
  static const int STEP_PAYMENT = 1;

  @override
  void onInit() {
    super.onInit();
    loadProfileAddresses();
  }

  /// Load addresses from profile/API
  Future<void> loadProfileAddresses() async {
    try {
      final addresses = await SharedPreferencesServices.getAddresses();
      profileAddresses.value = addresses;
    } catch (e) {
      print('Error loading addresses: $e');
    }
  }

  /// Main Place Order function for CART items with step-by-step process
  Future<void> initiateOrderProcess() async {
    try {
      // Check if user is logged in
      final isLoggedIn = await SharedPreferencesServices.getIsLoggedIn();
      if (!isLoggedIn) {
        _showLoginDialog();
        return;
      }

      // Set order type to cart
      orderType.value = 'cart';
      singleProductData.value = null;

      // Load addresses and show step-by-step dialog
      await loadProfileAddresses();
      currentStep.value = STEP_ADDRESS;
      _showOrderStepsDialog();
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  /// Buy Now function for SINGLE product with same step-by-step process
  Future<void> buyProduct({
    required String productId,
    required int quantity,
  }) async {
    try {
      // Check if user is logged in
      final isLoggedIn = await SharedPreferencesServices.getIsLoggedIn();
      if (!isLoggedIn) {
        _showLoginDialog();
        return;
      }

      // Set order type to single product
      orderType.value = 'single';
      singleProductData.value = {'productId': productId, 'quantity': quantity};

      // Load addresses and show step-by-step dialog
      await loadProfileAddresses();
      currentStep.value = STEP_ADDRESS;
      _showOrderStepsDialog();
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  /// Show step-by-step order dialog
  void _showOrderStepsDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.shopping_cart_checkout, color: AppColors.primaryColor),
              SizedBox(width: 8),
              Obx(
                () =>
                    Text(orderType.value == 'cart' ? 'Place Order' : 'Buy Now'),
              ),
            ],
          ),
          content: Container(
            width: Get.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress Indicator
                _buildProgressIndicator(),
                SizedBox(height: 20),

                // Step Content
                Obx(() {
                  switch (currentStep.value) {
                    case STEP_ADDRESS:
                      return _buildAddressSelectionStep();
                    case STEP_PAYMENT:
                      return _buildPaymentSelectionStep();
                    default:
                      return _buildAddressSelectionStep();
                  }
                }),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Get.back();
                _resetOrderProcess();
              },
              child: Text('Cancel'),
            ),

            // Next/Place Order Button
            Obx(() {
              final isLoading = orderType.value == 'cart'
                  ? isPlacingOrder.value
                  : isBuyProductLoading.value;
              return ElevatedButton(
                onPressed: isLoading ? null : _handleNextStep,
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                      style: TextStyle(color: AppColors.cardBackground),
                        currentStep.value == STEP_PAYMENT
                            ? (orderType.value == 'cart'
                                  ? 'Place Order'
                                  : 'Buy Now')
                            : 'Next',
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Build progress indicator
  Widget _buildProgressIndicator() {
    return Obx(() {
      return Row(
        children: [
          // Step 1 - Address
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: currentStep.value >= STEP_ADDRESS
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: Colors.white, size: 16),
          ),

          // Line connector
          Expanded(
            child: Container(
              height: 2,
              color: currentStep.value > STEP_ADDRESS
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
            ),
          ),

          // Step 2 - Payment
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: currentStep.value >= STEP_PAYMENT
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.payment, color: Colors.white, size: 16),
          ),
        ],
      );
    });
  }

  /// Build address selection step
  Widget _buildAddressSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Delivery Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        // Current Location Option
        Obx(() {
          return Card(
            child: ListTile(
              leading: Icon(Icons.my_location, color: AppColors.primaryColor),
              title: Text('Current Location'),
              subtitle: locationController.address.value.isNotEmpty
                  ? Text(
                      locationController.address.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text('Tap to get current location'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (locationController.isLoading.value)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showAddressForm(isCurrentLocation: true),
                  ),
                ],
              ),
              selected: selectedAddressType.value == 'current',
              onTap: () async {
                selectedAddressType.value = 'current';
                if (locationController.address.value.isEmpty) {
                  await locationController.getAddress();
                }
                selectedAddress.value = {
                  'type': 'current',
                  'fullName':
                      await SharedPreferencesServices.getUserName() ?? '',
                  'phone':
                      await SharedPreferencesServices.getPhoneNumber() ?? '',
                  'addressLine1': locationController.location.value,
                  'city': locationController.city.value,
                  'state': locationController.state.value,
                  'country': locationController.country.value,
                  'postalCode': locationController.pincode.value,
                };
              },
            ),
          );
        }),

        SizedBox(height: 12),

        // Profile Addresses
        Obx(() {
          if (profileAddresses.isEmpty) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.home, color: Colors.grey),
                title: Text('No Saved Address'),
                subtitle: Text('Add an address to your profile'),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Get.toNamed(AppRoutes.editProfileScreen),
                ),
              ),
            );
          }

          return Column(
            children: profileAddresses.map((address) {
              final index = profileAddresses.indexOf(address);
              return Card(
                child: ListTile(
                  leading: Icon(Icons.home, color: AppColors.primaryColor),
                  title: Text(address['fullName'] ?? 'Saved Address'),
                  subtitle: Text(
                    '${address['addressLine1']}, ${address['city']}, ${address['state']} ${address['postalCode']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showAddressForm(
                      existingAddress: address,
                      addressIndex: index,
                    ),
                  ),
                  selected: selectedAddressType.value == 'saved_$index',
                  onTap: () {
                    selectedAddressType.value = 'saved_$index';
                    selectedAddress.value = {...address, 'type': 'saved'};
                  },
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  /// Build payment selection step with dynamic summary
  Widget _buildPaymentSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        // Payment Options
        Obx(() {
          return Column(
            children: [
              // Card Payment
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: AppColors.primaryColor,
                  ),
                  title: Text('Card Payment'),
                  subtitle: Text('Pay with Credit/Debit Card'),
                  selected: selectedPaymentMethod.value == 'card',
                  onTap: () => selectedPaymentMethod.value = 'card',
                ),
              ),

              // Cash on Delivery
              Card(
                child: ListTile(
                  leading: Icon(Icons.money, color: Colors.green),
                  title: Text('Cash on Delivery'),
                  subtitle: Text('Pay when order is delivered'),
                  selected: selectedPaymentMethod.value == 'cod',
                  onTap: () => selectedPaymentMethod.value = 'cod',
                ),
              ),
            ],
          );
        }),

        SizedBox(height: 20),

        // Order Summary - Dynamic based on order type
        Obx(() => _buildOrderSummary()),
      ],
    );
  }

  /// Build dynamic order summary
  Widget _buildOrderSummary() {
    double itemsPrice = 0.0;
    int itemCount = 0;

    if (orderType.value == 'cart') {
      itemsPrice = cartController.totalPrice;
      itemCount = cartController.totalItems;
    } else if (singleProductData.value != null) {
      // For single product, you might need to get price from product details
      // For now, using a placeholder - you should fetch actual product price
      itemsPrice = 299.0; // Replace with actual product price
      itemCount = singleProductData.value!['quantity'];
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items ($itemCount)'),
              Text('₹${itemsPrice.toStringAsFixed(2)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Shipping'), Text('₹50.00')],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '₹${(itemsPrice + 50).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle next step or place order
  void _handleNextStep() {
    if (currentStep.value == STEP_ADDRESS) {
      if (selectedAddress.value == null) {
        HelperFunctions.showSnackbar(
          title: 'Address Required',
          message: 'Please select a delivery address',
          backgroundColor: Colors.orange,
        );
        return;
      }
      currentStep.value = STEP_PAYMENT;
    } else if (currentStep.value == STEP_PAYMENT) {
      _placeOrder();
    }
  }

  /// Place the actual order - handles both cart and single product
  Future<void> _placeOrder() async {
    try {
      if (orderType.value == 'cart') {
        isPlacingOrder.value = true;
      } else {
        isBuyProductLoading.value = true;
      }

      List<Map<String, dynamic>> products = [];

      // Prepare products based on order type
      if (orderType.value == 'cart') {
        final finalCartData = cartController.getFinalCartData();
        products = finalCartData
            .map(
              (item) => {
                'productId': item['productId'].toString(),
                'quantity': int.parse(item['quantity'].toString()),
              },
            )
            .toList();
      } else if (singleProductData.value != null) {
        products = [
          {
            'productId': singleProductData.value!['productId'].toString(),
            'quantity': singleProductData.value!['quantity'],
          },
        ];
      }

      print('Placing ${orderType.value} order with products: $products');

      final requestBody = {
        'products': products,
        'paymentMethod': selectedPaymentMethod.value,
        'shippingAddress': {
          'fullName': selectedAddress.value!['fullName'].toString(),
          'addressLine1': selectedAddress.value!['addressLine1'].toString(),
          'addressLine2':
              selectedAddress.value!['addressLine2']?.toString() ?? '',
          'city': selectedAddress.value!['city'].toString(),
          'state': selectedAddress.value!['state'].toString(),
          'postalCode': selectedAddress.value!['postalCode'].toString(),
          'country': selectedAddress.value!['country']?.toString() ?? 'India',
          'phone': selectedAddress.value!['phone'].toString(),
        },
        'notes':
            selectedAddress.value!['notes']?.toString() ??
            'Please deliver during evening hours.',
      };

      print('Request body: ${jsonEncode(requestBody)}');

      final response = await _apiServices.requestPostForApi(
        authToken: true,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/buy-product',
        dictParameter: requestBody,
      );

      if (response != null && response.statusCode == 201) {
        final data = response.data;

        Get.back(); // Close dialog
        _resetOrderProcess();

        HelperFunctions.showSnackbar(
          title: 'Success',
          message:
              data['message'] ??
              (orderType.value == 'cart'
                  ? 'Order placed successfully'
                  : 'Product purchased successfully'),
          backgroundColor: Colors.green,
        );

        // Clear cart only if it was a cart order
        if (orderType.value == 'cart') {
          // cartController.clearCart();
        }

        await fetchMyOrders();
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      HelperFunctions.showSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    } finally {
      if (orderType.value == 'cart') {
        isPlacingOrder.value = false;
      } else {
        isBuyProductLoading.value = false;
      }
    }
  }

  /// Show address form for editing
  void _showAddressForm({
    Map<String, dynamic>? existingAddress,
    int? addressIndex,
    bool isCurrentLocation = false,
  }) {
    final nameController = TextEditingController(
      text: existingAddress?['fullName'] ?? '',
    );
    final phoneController = TextEditingController(
      text: existingAddress?['phone'] ?? '',
    );
    final addressLine1Controller = TextEditingController(
      text:
          existingAddress?['addressLine1'] ??
          (isCurrentLocation ? locationController.location.value : ''),
    );
    final addressLine2Controller = TextEditingController(
      text: existingAddress?['addressLine2'] ?? '',
    );
    final cityController = TextEditingController(
      text:
          existingAddress?['city'] ??
          (isCurrentLocation ? locationController.city.value : ''),
    );
    final stateController = TextEditingController(
      text:
          existingAddress?['state'] ??
          (isCurrentLocation ? locationController.state.value : ''),
    );
    final pincodeController = TextEditingController(
      text:
          existingAddress?['postalCode'] ??
          (isCurrentLocation ? locationController.pincode.value : ''),
    );

    Get.dialog(
      AlertDialog(
        title: Text(existingAddress != null ? 'Edit Address' : 'Add Address'),
        content: Container(
          width: Get.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: addressLine1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: addressLine2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2 (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            
            onPressed: () async {
              final newAddress = {
                'fullName': nameController.text,
                'phone': phoneController.text,
                'addressLine1': addressLine1Controller.text,
                'addressLine2': addressLine2Controller.text,
                'city': cityController.text,
                'state': stateController.text,
                'postalCode': pincodeController.text,
                'country': 'India',
              };

              if (isCurrentLocation) {
                // Update current location address
                selectedAddress.value = {...newAddress, 'type': 'current'};
              } else if (addressIndex != null) {
                // Update existing address
                profileAddresses[addressIndex] = newAddress;
                await SharedPreferencesServices.saveAddresses(profileAddresses);
              } else {
                // Add new address
                profileAddresses.add(newAddress);
                await SharedPreferencesServices.saveAddresses(profileAddresses);
              }

              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Show login dialog
  void _showLoginDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Login Required'),
        content: Text('Please log in to place an order.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.loginScreen);
            },
            child: Text('Log In'),
          ),
        ],
      ),
    );
  }

  /// Reset order process
  void _resetOrderProcess() {
    currentStep.value = STEP_ADDRESS;
    selectedAddressType.value = '';
    selectedPaymentMethod.value = 'card';
    selectedAddress.value = null;
    isPlacingOrder.value = false;
    isBuyProductLoading.value = false;
    orderType.value = 'cart';
    singleProductData.value = null;
  }

  /// Add to existing fetchMyOrders method (from your original controller)
  Future<void> fetchMyOrders() async {
    // Your existing implementation
  }
}
