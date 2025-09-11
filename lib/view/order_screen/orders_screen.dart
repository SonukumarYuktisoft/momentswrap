// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momentswrap/controllers/order_controller/order_controller.dart';
// import 'package:momentswrap/models/order_model/order_model.dart';
// import 'package:momentswrap/view/order_screen/order_details_screen.dart';
// // Import your model classes here
// // import 'package:momentswrap/models/order_model.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   final OrderController _orderController = Get.put(OrderController());

//   @override
//   void initState() {
//     super.initState();
//     // Fetch orders when screen loads
//     _orderController.fetchMyOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'My Orders',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         actions: [
//           IconButton(
//             onPressed: () {
//               _orderController.fetchMyOrders();
//             },
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (_orderController.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (_orderController.myOrders.isEmpty) {
//           return _buildEmptyState();
//         }

//         return RefreshIndicator(
//           onRefresh: () async {
//             await _orderController.fetchMyOrders();
//           },
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: _orderController.myOrders.length,
//             itemBuilder: (context, index) {
//               final order = _orderController.myOrders[index];
//               return _buildOrderCard(order);
//             },
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.shopping_bag_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Orders Yet',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'You haven\'t placed any orders yet.',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to products screen
//               Get.back();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//             ),
//             child: const Text(
//               'Start Shopping',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderCard(OrderModel order) {
//     final mainProduct = _orderController.getMainProduct(order);
//     final totalQuantity = _orderController.getTotalQuantity(order);
//     final hasMultipleProducts = order.products.length > 1;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order #${_orderController.getFormattedOrderId(order.id)}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 _buildStatusChip(order.orderStatus),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // Product Info
//             if (mainProduct != null) ...[
//               Row(
//                 children: [
//                   // Product Image
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: mainProduct.product.images.isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               mainProduct.product.images.first,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(
//                                   Icons.image,
//                                   color: Colors.grey,
//                                   size: 30,
//                                 );
//                               },
//                             ),
//                           )
//                         : const Icon(
//                             Icons.image,
//                             color: Colors.grey,
//                             size: 30,
//                           ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           mainProduct.product.name,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         if (hasMultipleProducts) ...[
//                           Text(
//                             '${order.products.length} items • Total Qty: $totalQuantity',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ] else ...[
//                           Text(
//                             'Quantity: ${mainProduct.quantity}',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   Text(
//                     '₹${order.totalAmount.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             const SizedBox(height: 12),

//             // Order Details
//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   size: 16,
//                   color: Colors.grey[600],
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   _orderController.getFormattedDate(order.createdAt),
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),

//             if (order.shippingAddress != null) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 16,
//                     color: Colors.grey[600],
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       order.shippingAddress!.formattedAddress,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             // Payment Method
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(
//                   order.paymentMethod.toLowerCase() == 'cod'
//                       ? Icons.money
//                       : Icons.credit_card,
//                   size: 16,
//                   color: Colors.grey[600],
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   order.paymentMethod.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: order.paymentStatus.toLowerCase() == 'pending'
//                         ? Colors.orange.shade100
//                         : order.paymentStatus.toLowerCase() == 'paid'
//                             ? Colors.green.shade100
//                             : Colors.red.shade100,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     order.paymentStatus.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: order.paymentStatus.toLowerCase() == 'pending'
//                           ? Colors.orange.shade700
//                           : order.paymentStatus.toLowerCase() == 'paid'
//                               ? Colors.green.shade700
//                               : Colors.red.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       _viewOrderDetails(order.id);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                     ),
//                     child: const Text('View Details'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 if (order.orderStatus.toLowerCase() == 'pending') ...[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _showCancelOrderDialog(order.id, mainProduct?.product.name);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color backgroundColor;
//     Color textColor;

//     switch (status.toLowerCase()) {
//       case 'pending':
//         backgroundColor = Colors.orange.shade100;
//         textColor = Colors.orange.shade800;
//         break;
//       case 'confirmed':
//         backgroundColor = Colors.blue.shade100;
//         textColor = Colors.blue.shade800;
//         break;
//       case 'shipped':
//         backgroundColor = Colors.purple.shade100;
//         textColor = Colors.purple.shade800;
//         break;
//       case 'delivered':
//         backgroundColor = Colors.green.shade100;
//         textColor = Colors.green.shade800;
//         break;
//       case 'cancelled':
//         backgroundColor = Colors.red.shade100;
//         textColor = Colors.red.shade800;
//         break;
//       default:
//         backgroundColor = Colors.grey.shade100;
//         textColor = Colors.grey.shade800;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: textColor,
//         ),
//       ),
//     );
//   }

//   void _viewOrderDetails(String orderId) {
//     Get.to(() => OrderDetailsScreen(orderId: orderId));
//   }

//   void _showCancelOrderDialog(String orderId, String? productName) {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('Cancel Order'),
//         content: Text(
//           'Are you sure you want to cancel this order${productName != null ? ' for $productName' : ''}?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('No'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Get.back();
//               await _orderController.cancelOrder(orderId);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             child: const Text(
//               'Yes, Cancel',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/models/order_model/order_model.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/view/order_screen/order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderController _orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _orderController.fetchMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.accentColor,
                    size: 18,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _orderController.fetchMyOrders();
                    },
                    icon: Icon(
                      Icons.refresh_outlined,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
              ),
            ),

            // Orders Content
            SliverToBoxAdapter(
              child: Obx(() {
                if (_orderController.isLoading.value) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading your orders...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_orderController.myOrders.isEmpty) {
                  return _buildModernEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _orderController.fetchMyOrders();
                  },
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Orders Count Header
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                '${_orderController.myOrders.length} Orders Found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // Orders List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _orderController.myOrders.length,
                          itemBuilder: (context, index) {
                            final order = _orderController.myOrders[index];
                            return _buildModernOrderCard(order);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmptyState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: AppColors.accentColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppColors.accentColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(Icons.shopping_cart_outlined),
                label: Text(
                  'Start Shopping',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernOrderCard(OrderModel order) {
    final mainProduct = _orderController.getMainProduct(order);
    final totalQuantity = _orderController.getTotalQuantity(order);
    final hasMultipleProducts = order.products.length > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Order #${_orderController.getFormattedOrderId(order.id)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        _orderController.getFormattedDate(order.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildModernStatusChip(order.orderStatus),
              ],
            ),

            const SizedBox(height: 16),

            // Product Info with Modern Layout
            if (mainProduct != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    // Modern Product Image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: mainProduct.product.images.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                mainProduct.product.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_outlined,
                                    color: AppColors.primaryColor,
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.image_outlined,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainProduct.product.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (hasMultipleProducts) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${order.products.length} items',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Qty: $totalQuantity',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.successColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        _buildModernPaymentStatusBadge(order.paymentStatus),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Modern Order Details
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 16,
                        color: AppColors.secondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.paymentMethod.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (order.shippingAddress != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.secondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.shippingAddress!.formattedAddress,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Modern Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _viewOrderDetails(order.id),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.visibility_outlined, size: 16),
                      label: Text(
                        'View Details',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                if (order.orderStatus.toLowerCase() == 'pending') ...[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          _showModernCancelOrderDialog(
                            order.id,
                            mainProduct?.product.name,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.cancel_outlined, size: 16),
                        label: Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = AppColors.warningColor.withOpacity(0.2);
        textColor = AppColors.warningColor;
        icon = Icons.schedule_outlined;
        break;
      case 'confirmed':
        backgroundColor = AppColors.infoColor.withOpacity(0.2);
        textColor = AppColors.infoColor;
        icon = Icons.check_circle_outline;
        break;
      case 'shipped':
        backgroundColor = AppColors.secondaryColor.withOpacity(0.2);
        textColor = AppColors.secondaryColor;
        icon = Icons.local_shipping_outlined;
        break;
      case 'delivered':
        backgroundColor = AppColors.successColor.withOpacity(0.2);
        textColor = AppColors.successColor;
        icon = Icons.done_all_outlined;
        break;
      case 'cancelled':
        backgroundColor = AppColors.errorColor.withOpacity(0.2);
        textColor = AppColors.errorColor;
        icon = Icons.cancel_outlined;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey[600]!;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPaymentStatusBadge(String paymentStatus) {
    Color color;
    switch (paymentStatus.toLowerCase()) {
      case 'pending':
        color = AppColors.warningColor;
        break;
      case 'paid':
      case 'completed':
        color = AppColors.successColor;
        break;
      default:
        color = AppColors.errorColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        paymentStatus.toUpperCase(),
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _viewOrderDetails(String orderId) {
    Get.to(() => OrderDetailsScreen(orderId: orderId));
  }

  // void _showModernCancelOrderDialog(String orderId, String? productName) {
  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: AppColors.accentColor,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               color: AppColors.errorColor.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Icon(
  //               Icons.warning_amber_outlined,
  //               color: AppColors.errorColor,
  //               size: 20,
  //             ),
  //           ),
  //           SizedBox(width: 12),
  //           Text(
  //             'Cancel Order',
  //             style: TextStyle(
  //               color: AppColors.textColor,
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         'Are you sure you want to cancel this order${productName != null ? ' for $productName' : ''}? This action cannot be undone.',
  //         style: TextStyle(color: AppColors.textSecondary),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text(
  //             'Keep Order',
  //             style: TextStyle(color: AppColors.textSecondary),
  //           ),
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [
  //                 AppColors.errorColor,
  //                 AppColors.errorColor.withOpacity(0.8),
  //               ],
  //             ),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: TextButton(
  //             onPressed: () async {
  //               Get.back();
  //               await _orderController.cancelOrder(orderId: orderId, reason: null);
  //             },
  //             child: Text(
  //               'Yes, Cancel',
  //               style: TextStyle(
  //                 color: AppColors.accentColor,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _showModernCancelOrderDialog(String orderId, String? productName) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.warning_amber_outlined,
              color: AppColors.errorColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Cancel Order',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to cancel this order'
        '${productName != null ? ' for $productName' : ''}? '
        'This action cannot be undone.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Keep Order',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.errorColor,
                AppColors.errorColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () {
              Get.back(); // pehle dialog band karo
              _showCancelReasonBottomSheet(orderId, productName);
            },
            child: Text(
              'Yes, Cancel',
              style: TextStyle(
                color: AppColors.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showCancelReasonBottomSheet(String orderId, String? productName) {
  final reasons = [
    "Ordered by mistake",
    "Found cheaper elsewhere",
    "Item no longer needed",
    "Delivery time too long",
    "Ordered wrong product",
    "Better alternative available",
    "Changed my mind",
    "Product not required anymore",
    "Duplicate order",
    "Incorrect address",
    "Payment issue",
    "Gift order canceled",
    "Not satisfied with delivery options",
    "Shipping cost too high",
    "Expected faster delivery",
    "Review/ratings not good",
    "Not happy with seller",
    "Technical issue while ordering",
    "Applied wrong coupon",
    "Product not suitable",
    "Stock issue after order",
    "Delivery location not serviceable",
    "Other reason",
  ];

  String? selectedReason;
  final customReasonController = TextEditingController();

  Get.bottomSheet(
    SafeArea(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            height: Get.height * 0.65,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Select a reason for cancelling"
                  "${productName != null ? ' $productName' : ''}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: reasons.length,
                    itemBuilder: (context, index) {
                      final reason = reasons[index];
                      return RadioListTile<String>(
                        value: reason,
                        groupValue: selectedReason,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                            if (value != "Other reason") {
                              customReasonController.clear();
                            }
                          });
                        },
                        title: Text(
                          reason,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        activeColor: AppColors.errorColor,
                      );
                    },
                  ),
                ),
                if (selectedReason == "Other reason")
                  TextField(
                    controller: customReasonController,
                    decoration: InputDecoration(
                      hintText: "Please specify your reason",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: selectedReason == null
                      ? null
                      : () async {
                          String finalReason = selectedReason == "Other reason"
                              ? customReasonController.text.trim()
                              : selectedReason!;
      
                          if (finalReason.isEmpty) return;
      
                          Get.back(); // close bottom sheet
                          await _orderController.cancelOrder(
                            orderId: orderId,
                            reason: finalReason,
                          );
                        },
                  child: Text(
                    "Confirm Cancellation",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    isScrollControlled: true,
  );
}

}
