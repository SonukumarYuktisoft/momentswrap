import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/order_screen/controller/order_controller.dart';
import 'package:Xkart/view/reviews_screen/review_controller/review_controller.dart';
import 'package:Xkart/view/order_screen/model/order_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/view/order_screen/invoice_page.dart';
import 'package:Xkart/view/order_screen/widgets/review_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderController _orderController = Get.find<OrderController>();
  final ReviewController _reviewController = Get.put(ReviewController());

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
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Order #${_orderController.getFormattedOrderId(widget.orderId)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                    fontSize: 18,
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

            // Content
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
                            'Loading order details...',
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

                final order = _orderController.selectedOrder.value;
                if (order == null) {
                  return _buildModernErrorState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _orderController.fetchMyOrders();
                  },
                  color: AppColors.primaryColor,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildModernOrderStatusCard(order),
                        const SizedBox(height: 16),
                        _buildModernProductsList(order),
                        const SizedBox(height: 16),
                        _buildModernOrderInformation(order),
                        const SizedBox(height: 16),
                        _buildModernPaymentInformation(order),
                        const SizedBox(height: 16),
                        if (order.shippingAddress != null) ...[
                          _buildModernShippingAddress(order),
                          const SizedBox(height: 16),
                        ],
                        if (order.trackingNumber != null) ...[
                          _buildModernTrackingInformation(order),
                          const SizedBox(height: 16),
                        ],
                        if (order.notes != null && order.notes!.isNotEmpty) ...[
                          _buildModernNotesSection(order),
                          const SizedBox(height: 16),
                        ],
                        _buildModernActionButtons(order),
                        const SizedBox(height: 32),
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

  Widget _buildModernErrorState() {
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.errorColor.withOpacity(0.1),
                    AppColors.errorColor.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.errorColor.withOpacity(0.2),
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Not Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load order details.\nPlease try again.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _orderController.getOrderDetails(widget.orderId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.accentColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.refresh),
                    label: Text(
                      'Retry',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back),
                    label: Text(
                      'Go Back',
                      style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildModernOrderStatusCard(OrderModel order) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.timeline_outlined,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Order Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                _buildModernStatusChip(order.orderStatus),
              ],
            ),
            const SizedBox(height: 20),
            _buildModernStatusTimeline(order.orderStatus),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.update_outlined,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Last updated: ${_orderController.getFormattedDateTime(order.updatedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
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

  Widget _buildModernStatusTimeline(String status) {
    final statuses = ['pending', 'confirmed', 'shipped', 'delivered'];
    final currentIndex = statuses.indexWhere(
      (s) => s.toLowerCase() == status.toLowerCase(),
    );

    if (status.toLowerCase() == 'cancelled') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.errorColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.errorColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      color: AppColors.errorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This order has been cancelled and cannot be processed further.',
                    style: TextStyle(
                      color: AppColors.errorColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
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
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isCompleted || isActive
                          ? AppColors.primaryGradient
                          : null,
                      color: isCompleted || isActive
                          ? null
                          : AppColors.surfaceVariant,
                      border: Border.all(
                        color: isCompleted || isActive
                            ? Colors.transparent
                            : AppColors.primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.accentColor,
                          )
                        : isActive
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentColor,
                            ),
                          )
                        : null,
                  ),
                  if (index < statuses.length - 1)
                    Container(
                      width: 3,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: isCompleted
                            ? AppColors.primaryGradient
                            : null,
                        color: isCompleted
                            ? null
                            : AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
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
                            : FontWeight.w600,
                        color: isCompleted || isActive
                            ? AppColors.textColor
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (isActive)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Current Status',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildModernProductsList(OrderModel order) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.secondaryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Products (${order.products.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_orderController.getTotalQuantity(order)} items',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...order.products.asMap().entries.map((entry) {
              final index = entry.key;
              final orderProduct = entry.value;
              return Column(
                children: [
                  _buildModernProductItem(
                    orderProduct,
                    order,
                    orderProduct.product,
                  ),
                  if (index < order.products.length - 1)
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.primaryColor.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildModernProductItem(
    OrderProduct orderProduct,
    OrderModel order,
    ProductInfo productInfo,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: orderProduct.product.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      orderProduct.product.images.first,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.primaryColor,
                          size: 32,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
          ),
          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  orderProduct.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Short Description
                if (orderProduct.product.shortDescription.isNotEmpty) ...[
                  Text(
                    orderProduct.product.shortDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],

                // Quantity & Price
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 12,
                            color: AppColors.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Qty: ${orderProduct.quantity}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${productInfo.price.toStringAsFixed(0)} each',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₹${(productInfo.price * orderProduct.quantity).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Review Button
                if (order.orderStatus.toLowerCase() == 'delivered') ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,

                    child: ReviewButton(
                      orderProduct: orderProduct,
                      order: order,
                      productInfo: productInfo,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernOrderInformation(OrderModel order) {
    return Container(
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.infoColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Order Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  _buildModernInfoRow(
                    'Order ID',
                    order.formattedOrderId,
                    Icons.tag_outlined,
                  ),
                  _buildModernInfoDivider(),
                  _buildModernInfoRow(
                    'Order Date',
                    order.formattedDate,
                    Icons.calendar_today_outlined,
                  ),
                  _buildModernInfoDivider(),
                  _buildModernInfoRow(
                    'Created',
                    _orderController.getFormattedDateTime(order.createdAt),
                    Icons.schedule_outlined,
                  ),
                  _buildModernInfoDivider(),
                  _buildModernInfoRow(
                    'Total Items',
                    '${_orderController.getTotalQuantity(order)} items',
                    Icons.inventory_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.successColor.withOpacity(0.1),
                    AppColors.successColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.successColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        color: AppColors.successColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.successColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successColor,
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

  Widget _buildModernPaymentInformation(OrderModel order) {
    return Container(
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.payment_outlined,
                    color: AppColors.warningColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  _buildModernInfoRow(
                    'Payment Method',
                    order.paymentMethod.toUpperCase(),
                    order.paymentMethod.toLowerCase() == 'cod'
                        ? Icons.money
                        : Icons.credit_card,
                  ),
                  _buildModernInfoDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Payment Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(' : '),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                order.paymentStatus.toLowerCase() == 'pending'
                                ? AppColors.warningColor.withOpacity(0.1)
                                : order.paymentStatus.toLowerCase() == 'paid' ||
                                      order.paymentStatus.toLowerCase() ==
                                          'completed'
                                ? AppColors.successColor.withOpacity(0.1)
                                : AppColors.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.paymentStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  order.paymentStatus.toLowerCase() == 'pending'
                                  ? AppColors.warningColor
                                  : order.paymentStatus.toLowerCase() ==
                                            'paid' ||
                                        order.paymentStatus.toLowerCase() ==
                                            'completed'
                                  ? AppColors.successColor
                                  : AppColors.errorColor,
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
          ],
        ),
      ),
    );
  }

  Widget _buildModernShippingAddress(OrderModel order) {
    return Container(
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.secondaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  if (order.shippingAddress!.fullName.isNotEmpty) ...[
                    _buildModernInfoRow(
                      'Full Name',
                      order.shippingAddress!.fullName,
                      Icons.person_outline,
                    ),
                    _buildModernInfoDivider(),
                  ],
                  if (order.shippingAddress!.phoneNumber.isNotEmpty) ...[
                    _buildModernInfoRow(
                      'Phone',
                      order.shippingAddress!.phoneNumber,
                      Icons.phone_outlined,
                    ),
                    _buildModernInfoDivider(),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: AppColors.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.shippingAddress!.formattedAddress,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTrackingInformation(OrderModel order) {
    return Container(
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: AppColors.infoColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Tracking Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.infoColor.withOpacity(0.1),
                    AppColors.infoColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.infoColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.track_changes_outlined,
                    color: AppColors.infoColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tracking Number',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.infoColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.trackingNumber!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.infoColor,
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
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: _buildModernInfoRow(
                  'Estimated Delivery',
                  order.estimatedDelivery!,
                  Icons.schedule_outlined,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernNotesSection(OrderModel order) {
    return Container(
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    color: AppColors.warningColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Order Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warningColor.withOpacity(0.1),
                    AppColors.warningColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warningColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    color: AppColors.warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      order.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.warningColor,
                        fontWeight: FontWeight.w500,
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

  Widget _buildModernActionButtons(OrderModel order) {
    return Column(
      children: [
        if (order.orderStatus.toLowerCase() == 'pending') ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.errorColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.errorColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _orderController.isLoading.value
                  ? null
                  : () => _showModernCancelOrderDialog(order.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: AppColors.accentColor,
                disabledForegroundColor: AppColors.accentColor.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _orderController.isLoading.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentColor,
                        ),
                      ),
                    )
                  : Icon(Icons.cancel_outlined),
              label: Text(
                _orderController.isLoading.value
                    ? 'Cancelling...'
                    : 'Cancel Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (order.orderStatus.toLowerCase() == 'delivered') ...[
          Container(
            width: double.infinity,
            // decoration: BoxDecoration(
            //   // color: AppColors.accentColor,
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(
            //     color: AppColors.primaryColor.withOpacity(0.3),
            //   ),
            // ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.textOnPrimary,

                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back_outlined),
                    label: Text(
                      'Back to Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(InvoicePage(order: order));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.download),
                    label: Text(
                      'DownloadPDF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            child: TextButton.icon(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(Icons.arrow_back_outlined),
              label: Text(
                'Back to Orders',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],

        // Container(
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: AppColors.accentColor,
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        //   ),
        //   child: TextButton.icon(
        //     onPressed: () => Get.back(),
        //     style: TextButton.styleFrom(
        //       foregroundColor: AppColors.primaryColor,
        //       padding: const EdgeInsets.symmetric(vertical: 16),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(16),
        //       ),
        //     ),
        //     icon: Icon(Icons.arrow_back_outlined),
        //     label: Text(
        //       'Back to Orders',
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildModernInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 16),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(' : '),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primaryColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = AppColors.warningColor.withOpacity(0.1);
        textColor = AppColors.warningColor;
        icon = Icons.schedule_outlined;
        break;
      case 'confirmed':
        backgroundColor = AppColors.infoColor.withOpacity(0.1);
        textColor = AppColors.infoColor;
        icon = Icons.check_circle_outline;
        break;
      case 'shipped':
        backgroundColor = AppColors.secondaryColor.withOpacity(0.1);
        textColor = AppColors.secondaryColor;
        icon = Icons.local_shipping_outlined;
        break;
      case 'delivered':
        backgroundColor = AppColors.successColor.withOpacity(0.1);
        textColor = AppColors.successColor;
        icon = Icons.done_all_outlined;
        break;
      case 'cancelled':
        backgroundColor = AppColors.errorColor.withOpacity(0.1);
        textColor = AppColors.errorColor;
        icon = Icons.cancel_outlined;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[600]!;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
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

  // void _showModernCancelOrderDialog(String orderId) {
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
  //         'Are you sure you want to cancel this order? This action cannot be undone and you may not be able to place the same order again.',
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
  //               'Yes, Cancel Order',
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

  void _showModernCancelOrderDialog(String orderId) {
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
          'Are you sure you want to cancel this order? This action cannot be undone.',
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
                Get.back(); // Close dialog
                _showCancelReasonBottomSheet(orderId); // Open reason sheet
              },
              child: Text(
                'Yes, Cancel Order',
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

  void _showCancelReasonBottomSheet(String orderId) {
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

    Get.bottomSheet(
      SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: Get.height * 0.65,

              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Select a reason for cancellation",
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
                            setState(() => selectedReason = value);
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
                            Get.back(); // close bottom sheet
                            await _orderController.cancelOrder(
                              orderId: orderId,
                              reason: selectedReason,
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
