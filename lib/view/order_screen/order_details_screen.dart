import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/models/order_model/order_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    // Check if order is already loaded in myOrders, otherwise fetch details
    final existingOrder = _orderController.myOrders.firstWhereOrNull(
      (order) => order.id == widget.orderId,
    );

    if (existingOrder != null) {
      _orderController.selectedOrder.value = existingOrder;
    } else {
      _orderController.getOrderDetails(widget.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${_orderController.getFormattedOrderId(widget.orderId)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = _orderController.selectedOrder.value;
        if (order == null) {
          return _buildErrorState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _orderController.getOrderDetails(widget.orderId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderStatusCard(order),
                const SizedBox(height: 16),
                _buildProductsList(order),
                const SizedBox(height: 16),
                _buildOrderInformation(order),
                const SizedBox(height: 16),
                _buildPaymentInformation(order),
                const SizedBox(height: 16),
                if (order.shippingAddress != null) ...[
                  _buildShippingAddress(order),
                  const SizedBox(height: 16),
                ],
                if (order.trackingNumber != null) ...[
                  _buildTrackingInformation(order),
                  const SizedBox(height: 16),
                ],
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  _buildNotesSection(order),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                _buildActionButtons(order),
                const SizedBox(height: 32), // Extra padding at bottom
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Order Not Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unable to load order details.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _orderController.getOrderDetails(widget.orderId);
                },
                child: const Text('Retry'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(order.orderStatus),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusTimeline(order.orderStatus),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last updated: ${_orderController.getFormattedDateTime(order.updatedAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(String status) {
    final statuses = ['pending', 'confirmed', 'shipped', 'delivered'];
    final currentIndex = statuses.indexWhere(
      (s) => s.toLowerCase() == status.toLowerCase(),
    );

    if (status.toLowerCase() == 'cancelled') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.red.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This order has been cancelled and cannot be processed further.',
                    style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final statusName = entry.value;
        final isCompleted = index <= currentIndex && currentIndex >= 0;
        final isActive = index == currentIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : isActive
                          ? Colors.orange
                          : Colors.grey.shade300,
                      border: Border.all(
                        color: isCompleted || isActive
                            ? Colors.transparent
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : isActive
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  if (index < statuses.length - 1)
                    Container(
                      width: 2,
                      height: 32,
                      color: isCompleted ? Colors.green : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isCompleted || isActive
                            ? Colors.black
                            : Colors.grey.shade600,
                      ),
                    ),
                    if (isActive)
                      Text(
                        'Current Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductsList(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products (${order.products.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_orderController.getTotalQuantity(order)} items',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            const Divider(height: 24),
            ...order.products.asMap().entries.map((entry) {
              final index = entry.key;
              final orderProduct = entry.value;
              return Column(
                children: [
                  _buildProductItem(orderProduct),
                  if (index < order.products.length - 1)
                    const Divider(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(OrderProduct orderProduct) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: orderProduct.product.images.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    orderProduct.product.images.first,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 32,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.grey,
                  size: 32,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderProduct.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (orderProduct.product.shortDescription.isNotEmpty) ...[
                Text(
                  orderProduct.product.shortDescription,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Qty: ${orderProduct.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${orderProduct.price.toStringAsFixed(0)} each',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${(orderProduct.price * orderProduct.quantity).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInformation(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _buildInfoRow('Order ID', order.formattedOrderId),
            const SizedBox(height: 12),
            _buildInfoRow('Order Date', order.formattedDate),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Created',
              _orderController.getFormattedDateTime(order.createdAt),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Total Items',
              '${_orderController.getTotalQuantity(order)} items',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInformation(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _buildInfoRow('Payment Method', order.paymentMethod.toUpperCase()),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Payment Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(': '),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.paymentStatus.toLowerCase() == 'pending'
                          ? Colors.orange.shade100
                          : order.paymentStatus.toLowerCase() == 'paid' ||
                                order.paymentStatus.toLowerCase() == 'completed'
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.paymentStatus.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: order.paymentStatus.toLowerCase() == 'pending'
                            ? Colors.orange.shade700
                            : order.paymentStatus.toLowerCase() == 'paid' ||
                                  order.paymentStatus.toLowerCase() ==
                                      'completed'
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingAddress(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            if (order.shippingAddress!.fullName.isNotEmpty) ...[
              _buildInfoRow('Full Name', order.shippingAddress!.fullName),
              const SizedBox(height: 12),
            ],
            if (order.shippingAddress!.phoneNumber.isNotEmpty) ...[
              _buildInfoRow('Phone', order.shippingAddress!.phoneNumber),
              const SizedBox(height: 12),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.shippingAddress!.formattedAddress,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingInformation(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: Colors.blue.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tracking Number',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.trackingNumber!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (order.estimatedDelivery != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Estimated Delivery', order.estimatedDelivery!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(OrderModel order) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(OrderModel order) {
    return Column(
      children: [
        if (order.orderStatus.toLowerCase() == 'pending') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _orderController.isLoading.value
                  ? null
                  : () => _showCancelOrderDialog(order.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                disabledBackgroundColor: Colors.red.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _orderController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Cancel Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Back to Orders', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.schedule;
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Icons.check_circle_outline;
        break;
      case 'shipped':
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        icon = Icons.local_shipping;
        break;
      case 'delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.done_all;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(String orderId) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            const Text('Cancel Order'),
          ],
        ),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone and you may not be able to place the same order again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Keep Order'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _orderController.cancelOrder(orderId);
              // The screen will automatically update due to Obx reactivity
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Yes, Cancel Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
