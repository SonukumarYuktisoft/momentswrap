// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
// // import 'package:momentswrap/controllers/order_controller/order_controller.dart';
// // import 'package:momentswrap/util/constants/app_sizes.dart';
// // import 'package:momentswrap/util/helpers/date_time_helper.dart';
// // import 'package:momentswrap/view/add_to_cart_screen/cart_Item_card.dart';

// // class AddToCartScreen extends StatefulWidget {
// //   const AddToCartScreen({super.key});

// //   @override
// //   State<AddToCartScreen> createState() => _AddToCartScreenState();
// // }

// // class _AddToCartScreenState extends State<AddToCartScreen> {
// //   final CartController cartController = Get.put(CartController());
// //   final OrderController orderController = Get.put(OrderController());
// //   final TextEditingController voucherController = TextEditingController();

// //   String selectedDeliveryDate = 'Pick delivery date';
// //   double shippingPrice = 10.0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch carts when screen is initialized
// //     cartController.fetchCarts();
// //   }

// //   @override
// //   void dispose() {
// //     voucherController.dispose();
// //     super.dispose();
// //   }

// //   // Calculate subtotal from cart items
// //   // double get subtotal {
// //   //   if (cartController.carts.value?.data.isEmpty ?? true) return 0.0;
// //   //   return cartController.carts.value!.data.fold(0.0, (sum, item) {
// //   //     return sum + (item.product.price * item.quantity);
// //   //   });
// //   // }

// //   // Calculate total
// //   // double get total => subtotal + shippingPrice;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Shopping Cart'),
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         elevation: 1,
// //         actions: [
// //           Obx(() {
// //             final itemCount = cartController.totalItems;
// //             return Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: Center(
// //                 child: Text(
// //                   '$itemCount items',
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }),
// //         ],
// //       ),
// //       body: Obx(() {
// //         // if (cartController.isCartLoading.value) {
// //         //   return const Center(child: CircularProgressIndicator());
// //         // }

// //         if (cartController.carts.value == null ||
// //             cartController.carts.value!.data.isEmpty) {
// //           return _buildEmptyCart();
// //         }

// //         return _buildCartWithItems();
// //       }),
// //     );
// //   }

// //   Widget _buildEmptyCart() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
// //           const SizedBox(height: 16),
// //           const Text(
// //             'Your cart is empty',
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Add some items to get started',
// //             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
// //           ),
// //           const SizedBox(height: 24),
// //           ElevatedButton(
// //             onPressed: () {
// //               // Navigate to products or home screen
// //               Get.back();
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.blue,
// //               foregroundColor: Colors.white,
// //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //             child: const Text('Start Shopping'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCartWithItems() {
// //     return Column(
// //       children: [
// //         // Cart Items List
// //         Expanded(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(AppSizes.defaultSpacing),
// //             child: Column(
// //               children: [
// //                 // Cart Items
// //                 RefreshIndicator(
// //                   onRefresh: () async {
// //                     return cartController.fetchCarts();
// //                   },
// //                   child: ListView.builder(
// //                     shrinkWrap: true,
// //                     physics: const NeverScrollableScrollPhysics(),
// //                     itemCount: cartController.carts.value!.data.length,
// //                     itemBuilder: (context, index) {
// //                       final cartItem = cartController.carts.value!.data[index];
// //                       final product = cartItem.product;

// //                       return CartItemCard(
// //                         imageUrl: product.images.isNotEmpty
// //                             ? product.images[0]
// //                             : '',
// //                         title: product.name,
// //                         price: product.price.toDouble(),
// //                         quantity: cartItem.quantity,
// //                         productId: cartItem.id,
// //                         onIncrease: () {
// //                           // Update quantity in cart
// //                           cartController.addToCart(
// //                             productId: product.id,
// //                             quantity: 1,
// //                             totalPrice: product.price.toDouble(),
// //                             image: product.images.isNotEmpty
// //                                 ? product.images[0]
// //                                 : '',
// //                           );
// //                         },
// //                         onDecrease: () {
// //                           // Update quantity in cart
// //                           if (cartItem.quantity > 1) {
// //                             // TODO: Implement API to update quantity
// //                             // For now, we'll remove and add with new quantity
// //                             // cartController.removeFromCart(cartItem.id);
// //                             cartController.addToCart(
// //                               productId: product.id,
// //                               quantity:  -1,
// //                               totalPrice: product.price.toDouble(),
// //                               image: product.images.isNotEmpty
// //                                   ? product.images[0]
// //                                   : '',
// //                             );
// //                           } else {
// //                             cartController.removeFromCart(product.id);
// //                           }
// //                         },
// //                         onDelete: () async {
// //                           await cartController.removeFromCart(product.id);
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),

// //                 const SizedBox(height: 16),

// //                 // Shipping Card
// //                 // _buildShippingCard(),
// //                 const SizedBox(height: 12),

// //                 // Voucher Card
// //                 // _buildVoucherCard(),
// //                 const SizedBox(height: 16),

// //                 // Cart Summary
// //                 // _buildCartSummary(),
// //               ],
// //             ),
// //           ),
// //         ),

// //         // Bottom Section - Place Order
// //         _buildPlaceOrderSection(),
// //       ],
// //     );
// //   }

// //   Widget _buildShippingCard() {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Row(
// //           children: [
// //             Icon(Icons.local_shipping, color: Colors.orange[600], size: 24),
// //             const SizedBox(width: 12),
// //             Text(
// //               "Shipping \₹${shippingPrice.toStringAsFixed(0)}",
// //               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
// //             ),
// //             const Spacer(),
// //             Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
// //             const SizedBox(width: 8),
// //             Text(
// //               selectedDeliveryDate,
// //               style: TextStyle(color: Colors.grey[700], fontSize: 14),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 final pickedDate = await DateTimeHelper.selectDateTime(
// //                   context: context,
// //                 );
// //                 if (pickedDate != null) {
// //                   setState(() {
// //                     selectedDeliveryDate = pickedDate.toString().split(' ')[0];
// //                   });
// //                 }
// //               },
// //               child: const Text("Change"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildVoucherCard() {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Row(
// //           children: [
// //             Icon(Icons.card_giftcard, color: Colors.amber[700], size: 24),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: TextField(
// //                 controller: voucherController,
// //                 decoration: const InputDecoration(
// //                   hintText: "Enter voucher code",
// //                   border: InputBorder.none,
// //                   contentPadding: EdgeInsets.zero,
// //                 ),
// //               ),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 // TODO: Implement voucher application logic
// //                 if (voucherController.text.isNotEmpty) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                       content: Text('Voucher application feature coming soon!'),
// //                     ),
// //                   );
// //                 }
// //               },
// //               child: const Text("Apply"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCartSummary() {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             // _summaryRow("Subtotal", subtotal),
// //             // _summaryRow("Shipping", shippingPrice),
// //             const Padding(
// //               padding: EdgeInsets.symmetric(vertical: 8),
// //               child: Divider(height: 1),
// //             ),
// //             _summaryRow(
// //               "Total amount",
// //               cartController.totalPrice,
// //               isTotal: true,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _summaryRow(String label, double amount, {bool isTotal = false}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
// //               fontSize: isTotal ? 18 : 16,
// //             ),
// //           ),
// //           Text(
// //             "\₹${amount.toStringAsFixed(2)}",
// //             style: TextStyle(
// //               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
// //               fontSize: isTotal ? 18 : 16,
// //               color: isTotal ? Colors.green[600] : Colors.black87,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPlaceOrderSection() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.2),
// //             spreadRadius: 1,
// //             blurRadius: 5,
// //             offset: const Offset(0, -3),
// //           ),
// //         ],
// //       ),
// //       child: SafeArea(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const Text(
// //                   "Total:",
// //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                 ),
// //                 Text(
// //                   "\₹${cartController.totalPrice.toStringAsFixed(2)}",
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.green[600],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.pink[100],
// //                   foregroundColor: Colors.black,
// //                   padding: const EdgeInsets.symmetric(vertical: 16),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //                 onPressed: () {
// //                   final cartItem = cartController.carts.value!.data;
// //                   final productsToBuy = cartItem.map((item) {
// //                     return {
// //                       'productId': item.product.id,
// //                       'quantity': item.quantity,
// //                     };
// //                   }).toList();
// //                   orderController.buyProductsBulk(productsToBuy);

// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                       content: Text(
// //                         'Place order functionality will be implemented!',
// //                       ),
// //                       backgroundColor: Colors.green,
// //                     ),
// //                   );
// //                 },
// //                 icon: const Icon(Icons.shopping_cart_checkout),
// //                 label: const Text(
// //                   "Place Order",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
// import 'package:momentswrap/controllers/order_controller/order_controller.dart';
// import 'package:momentswrap/util/constants/app_sizes.dart';
// import 'package:momentswrap/util/helpers/date_time_helper.dart';
// import 'package:momentswrap/view/add_to_cart_screen/cart_Item_card.dart';

// class AddToCartScreen extends StatefulWidget {
//   const AddToCartScreen({super.key});

//   @override
//   State<AddToCartScreen> createState() => _AddToCartScreenState();
// }

// class _AddToCartScreenState extends State<AddToCartScreen> {
//   final CartController cartController = Get.put(CartController());
//   final OrderController orderController = Get.put(OrderController());
//   final TextEditingController voucherController = TextEditingController();

//   String selectedDeliveryDate = 'Pick delivery date';
//   double shippingPrice = 10.0;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch carts when screen is initialized
//     cartController.fetchCarts();
//   }

//   @override
//   void dispose() {
//     voucherController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shopping Cart'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         actions: [
//           Obx(() {
//             final itemCount = cartController.totalItems;
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Center(
//                 child: Text(
//                   '$itemCount items',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//       body: Obx(() {
//         if (cartController.isCartLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (cartController.carts.value == null ||
//             cartController.carts.value!.data.isEmpty) {
//           return _buildEmptyCart();
//         }

//         return _buildCartWithItems();
//       }),
//     );
//   }

//   Widget _buildEmptyCart() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           const Text(
//             'Your cart is empty',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Add some items to get started',
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text('Start Shopping'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCartWithItems() {
//     return Column(
//       children: [
//         // Cart Items List
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(AppSizes.defaultSpacing),
//             child: Column(
//               children: [
//                 // Cart Items
//                 RefreshIndicator(
//                   onRefresh: () async {
//                     return cartController.fetchCarts();
//                   },
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: cartController.carts.value!.data.length,
//                     itemBuilder: (context, index) {
//                       final cartItem = cartController.carts.value!.data[index];
//                       final product = cartItem.product;

//                       return CartItemCard(
//                         imageUrl: product.images.isNotEmpty
//                             ? product.images[0]
//                             : '',
//                         title: product.name,
//                         price: product.price.toDouble(),
//                         initialQuantity: cartItem.quantity, // API quantity
//                         productId: product.id,
//                         cartItemId: cartItem.id, // For local quantity management
//                         onDelete: () async {
//                           await cartController.removeFromCart(product.id);
//                         },
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Cart Summary
//                 _buildCartSummary(),
//               ],
//             ),
//           ),
//         ),

//         // Bottom Section - Place Order
//         _buildPlaceOrderSection(),
//       ],
//     );
//   }

//   Widget _buildCartSummary() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _summaryRow("Subtotal", cartController.totalPrice),
//             _summaryRow("Shipping", shippingPrice),
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               child: Divider(height: 1),
//             ),
//             _summaryRow(
//               "Total amount",
//               cartController.totalPrice + shippingPrice,
//               isTotal: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//               fontSize: isTotal ? 18 : 16,
//             ),
//           ),
//           Text(
//             "\₹${amount.toStringAsFixed(2)}",
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//               fontSize: isTotal ? 18 : 16,
//               color: isTotal ? Colors.green[600] : Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlaceOrderSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Obx(() {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Total:",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "\₹${(cartController.totalPrice + shippingPrice).toStringAsFixed(2)}",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green[600],
//                     ),
//                   ),
//                 ],
//               );
//             }),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink[100],
//                   foregroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Get final cart data with local quantities
//                   final finalCartData = cartController.getFinalCartData();

//                   // Debug: Print the final data that will be passed to order
//                   print('Final Cart Data for Order: $finalCartData');

//                   // Convert to the format expected by your order API
//                   final productsToBuy = finalCartData.map((item) {
//                     return {
//                       'productId': item['productId'],
//                       'quantity': item['quantity'],
//                     };
//                   }).toList();

//                   print('Products to Buy: $productsToBuy');

//                   // Call the order controller
//                   orderController.buyProductsBulk(productsToBuy);

//                   // Show success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Order placed with ${cartController.totalItems} items totaling ₹${(cartController.totalPrice + shippingPrice).toStringAsFixed(2)}',
//                       ),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.shopping_cart_checkout),
//                 label: const Text(
//                   "Place Order",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Show what will be ordered
//             Obx(() {
//               if (cartController.carts.value?.data.isNotEmpty ?? false) {
//                 return Text(
//                   'Ready to order ${cartController.totalItems} items',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/helpers/date_time_helper.dart';
import 'package:momentswrap/view/add_to_cart_screen/cart_Item_card.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final TextEditingController voucherController = TextEditingController();

  String selectedDeliveryDate = 'Pick delivery date';
  double shippingPrice = 10.0;

  @override
  void initState() {
    super.initState();
    cartController.fetchCarts();
  }

  @override
  void dispose() {
    voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        // leading: Container(
        //   margin: EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //     color: AppColors.primaryLight,
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back_ios_new,
        //       color: AppColors.primaryColor,
        //       size: 20,
        //     ),
        //     onPressed: () => Get.back(),
        //   ),
        // ),
        actions: [
          Obx(() {
            final itemCount = cartController.totalItems;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$itemCount items',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.accentColor,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.isCartLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryColor),
                SizedBox(height: 16),
                Text(
                  'Loading your cart...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (cartController.carts.value == null ||
            cartController.carts.value!.data.isEmpty) {
          return _buildModernEmptyCart();
        }

        return _buildModernCartWithItems();
      }),
    );
  }

  Widget _buildModernEmptyCart() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundColor, AppColors.accentColor],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some amazing products to get started',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.accentColor,
                ),
                label: Text(
                  'Start Shopping',
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCartWithItems() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundColor, AppColors.accentColor],
        ),
      ),
      child: Column(
        children: [
          // Cart Items List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Modern Cart Items
                  RefreshIndicator(
                    onRefresh: () async {
                      return cartController.fetchCarts();
                    },
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartController.carts.value!.data.length,
                      itemBuilder: (context, index) {
                        final cartItem =
                            cartController.carts.value!.data[index];
                        final product = cartItem.product;

                        return ModernCartItemCard(
                          imageUrl: product.images.isNotEmpty
                              ? product.images[0]
                              : '',
                          title: product.name,
                          price: product.price.toDouble(),
                          initialQuantity: cartItem.quantity,
                          productId: product.id,
                          cartItemId: cartItem.id,
                          onDelete: () async {
                            await cartController.removeFromCart(product.id);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Modern Cart Summary
                  _buildModernCartSummary(),
                ],
              ),
            ),
          ),

          // Modern Bottom Section
          _buildModernPlaceOrderSection(),
        ],
      ),
    );
  }

  Widget _buildModernCartSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _modernSummaryRow("Subtotal", cartController.totalPrice),
          _modernSummaryRow("Shipping", shippingPrice),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: AppColors.primaryColor.withOpacity(0.2),
              height: 1,
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _modernSummaryRow(
              "Total Amount",
              cartController.totalPrice + shippingPrice,
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppColors.primaryColor : AppColors.textSecondary,
          ),
        ),
        Text(
          "\₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? AppColors.primaryColor : AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildModernPlaceOrderSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Amount Display
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "\₹${(cartController.totalPrice + shippingPrice).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shopping_cart_checkout,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            // Modern Place Order Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    final finalCartData = cartController.getFinalCartData();

                    final productsToBuy = finalCartData.map((item) {
                      return {
                        'productId': item['productId'],
                        'quantity': item['quantity'],
                      };
                    }).toList();

                    orderController.buyProductsBulk(productsToBuy);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColors.accentColor,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Order placed with ${cartController.totalItems} items totaling ₹${(cartController.totalPrice + shippingPrice).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppColors.accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: AppColors.successColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                  icon: const Icon(Icons.flash_on_outlined),
                  label: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Order Summary Text
            Obx(() {
              if (cartController.carts.value?.data.isNotEmpty ?? false) {
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.secondaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ready to order ${cartController.totalItems} items',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

// Modern Cart Item Card Component
class ModernCartItemCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;
  final int initialQuantity;
  final String productId;
  final String cartItemId;
  final VoidCallback? onDelete;

  const ModernCartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.initialQuantity,
    required this.productId,
    required this.cartItemId,
    this.onDelete,
  });

  @override
  State<ModernCartItemCard> createState() => _ModernCartItemCardState();
}

class _ModernCartItemCardState extends State<ModernCartItemCard> {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Modern Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.imageUrl.isNotEmpty
                    ? widget.imageUrl
                    : 'https://via.placeholder.com/80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '\₹${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),

                // Modern Quantity Controls
                Obx(() {
                  final localQuantity = cartController.getLocalQuantity(
                    widget.cartItemId,
                  );

                  return Row(
                    children: [
                      _ModernQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          cartController.decreaseLocalQuantity(
                            widget.cartItemId,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$localQuantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _ModernQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          cartController.increaseLocalQuantity(
                            widget.cartItemId,
                          );
                        },
                      ),
                      const SizedBox(width: 12),

                      // Modified indicator
                      // if (localQuantity != widget.initialQuantity)
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 8,
                      //       vertical: 4,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: AppColors.warningColor.withOpacity(0.2),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     child: Text(
                      //       'Modified',
                      //       style: TextStyle(
                      //         fontSize: 10,
                      //         color: AppColors.warningColor,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Delete Button and Total
          Column(
            children: [
              Obx(() {
                return cartController.isRemoveFromCartLoading.value
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final shouldDelete =
                                await _showModernDeleteConfirmation(context);
                            if (shouldDelete) {
                              widget.onDelete?.call();
                            }
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.errorColor,
                            size: 20,
                          ),
                        ),
                      );
              }),
              const SizedBox(height: 8),

              // Dynamic total calculation
              Obx(() {
                final localQuantity = cartController.getLocalQuantity(
                  widget.cartItemId,
                );
                final total = widget.price * localQuantity;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${total.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showModernDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warningColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Remove Item',
                  style: TextStyle(color: AppColors.textColor),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to remove this item from your cart?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.errorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _ModernQuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ModernQuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.2)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: AppColors.secondaryColor),
        onPressed: onPressed,
      ),
    );
  }
}
