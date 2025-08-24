import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/models/order_model/order_model.dart';
import 'package:momentswrap/view/order_screen/order_details_screen.dart';
// Import your model classes here
// import 'package:momentswrap/models/order_model.dart';

class ListMyOrdersScreen extends StatefulWidget {
  const ListMyOrdersScreen({super.key});

  @override
  State<ListMyOrdersScreen> createState() => _ListMyOrdersScreenState();
}

class _ListMyOrdersScreenState extends State<ListMyOrdersScreen> {
  final OrderController _orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Fetch orders when screen loads
    _orderController.fetchMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              _orderController.fetchMyOrders();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_orderController.myOrders.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _orderController.fetchMyOrders();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _orderController.myOrders.length,
            itemBuilder: (context, index) {
              final order = _orderController.myOrders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t placed any orders yet.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to products screen
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final mainProduct = _orderController.getMainProduct(order);
    final totalQuantity = _orderController.getTotalQuantity(order);
    final hasMultipleProducts = order.products.length > 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${_orderController.getFormattedOrderId(order.id)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.orderStatus),
              ],
            ),
            const SizedBox(height: 12),
            
            // Product Info
            if (mainProduct != null) ...[
              Row(
                children: [
                  // Product Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: mainProduct.product.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              mainProduct.product.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainProduct.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (hasMultipleProducts) ...[
                          Text(
                            '${order.products.length} items • Total Qty: $totalQuantity',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Quantity: ${mainProduct.quantity}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Order Details
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  _orderController.getFormattedDate(order.createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            if (order.shippingAddress != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.shippingAddress!.formattedAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            // Payment Method
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  order.paymentMethod.toLowerCase() == 'cod' 
                      ? Icons.money 
                      : Icons.credit_card,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  order.paymentMethod.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: order.paymentStatus.toLowerCase() == 'pending'
                        ? Colors.orange.shade100
                        : order.paymentStatus.toLowerCase() == 'paid'
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.paymentStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: order.paymentStatus.toLowerCase() == 'pending'
                          ? Colors.orange.shade700
                          : order.paymentStatus.toLowerCase() == 'paid'
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _viewOrderDetails(order.id);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                if (order.orderStatus.toLowerCase() == 'pending') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelOrderDialog(order.id, mainProduct?.product.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
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

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'shipped':
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;
      case 'delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  void _viewOrderDetails(String orderId) {
    Get.to(() => OrderDetailsScreen(orderId: orderId));
  }

  void _showCancelOrderDialog(String orderId, String? productName) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: Text(
          'Are you sure you want to cancel this order${productName != null ? ' for $productName' : ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _orderController.cancelOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}