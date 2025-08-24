import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/instance_manager.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/helpers/date_time_helper.dart';
import 'package:momentswrap/view/add_to_cart_screen/cart_Item_card.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // OrderController orderController = Get.find<OrderController>();
    OrderController orderController = Get.put(OrderController());
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpacing),
          child: Column(
            children: [
                
                // ElevatedButton(onPressed: () => cartController.fetchCarts(), child:Text('chake cart')),
               
              Obx(() {
                if (cartController.isCartLoading.value) {
                  return const CircularProgressIndicator();
                } else if (cartController.carts.value == null ||
                    cartController.carts.value!.data.isEmpty) {
                  return Center(child: Text(cartController.errorMessage.value));
                }

                if (cartController.carts.value == null ||
                    cartController.carts.value!.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add some items to get started',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    // Cart Items List
                    RefreshIndicator(
                      onRefresh: () async {
                        await cartController.fetchCarts();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: cartController.carts.value!.data.length,
                          itemBuilder: (context, index) {
                            final cartItem =
                                cartController.carts.value!.data[index];
                            final product = cartItem.product;
                            

                            return CartItemCard(
                              imageUrl: cartItem.image ?? '',
                              title: product?.name ?? 'Unknown Product',
                              price: cartItem.price,
                              quantity: cartItem.quantity,
                              onIncrease: () {},
                              onDecrease: () {},
                              onDelete: () {},
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),

              ShippingCard(
                shippingPrice: 10,
                deliveryDate: 'Pick delivery date',
                onChange: () async {
                  final pickedDate = await DateTimeHelper.selectDateTime(
                    context: context,
                  );
                },
              ),

              VoucherCard(controller: TextEditingController(), onApply: () {}),
              const SizedBox(height: 10),
              CartSummary(subtotal: 34.9, shipping: 10, total: 44.9),
              PlaceOrderButton(
                onPressed: () {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.blue.shade100,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: Colors.blue),
        onPressed: onPressed,
      ),
    );
  }
}

// 2️⃣ Shipping Card
class ShippingCard extends StatelessWidget {
  final double shippingPrice;
  final String deliveryDate;
  final VoidCallback onChange;

  const ShippingCard({
    super.key,
    required this.shippingPrice,
    required this.deliveryDate,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.local_shipping, color: Colors.orange),
            const SizedBox(width: 8),
            Text("Shipping \$${shippingPrice.toStringAsFixed(0)}"),
            const Spacer(),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            const SizedBox(width: 6),
            Text(deliveryDate),
            TextButton(onPressed: onChange, child: const Text("Change")),
          ],
        ),
      ),
    );
  }
}

// 3️⃣ Voucher Card
class VoucherCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;

  const VoucherCard({
    super.key,
    required this.controller,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Add Voucher",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextButton(onPressed: onApply, child: const Text("Apply")),
          ],
        ),
      ),
    );
  }
}

// 4️⃣ Cart Summary
class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _summaryRow("Subtotal", subtotal),
        _summaryRow("Shipping", shipping),
        const Divider(),
        _summaryRow("Total amount", total, isTotal: true),
      ],
    );
  }

  Widget _summaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(1)}",
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// 5️⃣ Place Order Button
class PlaceOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlaceOrderButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.shade100,
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.shopping_cart_checkout, color: Colors.black),
      label: const Text("Place order", style: TextStyle(color: Colors.black)),
    );
  }
}

// 🔹 Main Cart Screen
class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final voucherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // List of Cart Items
            CartItemCard(
              imageUrl: "https://via.placeholder.com/150",
              title: "LED Starry Sky",
              price: 4.9,
              quantity: 1,
              onIncrease: () {},
              onDecrease: () {},
              onDelete: () {},
            ),
            CartItemCard(
              imageUrl: "https://via.placeholder.com/150",
              title: "Birthday Hamper",
              price: 30,
              quantity: 1,
              onIncrease: () {},
              onDecrease: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 10),
            ShippingCard(
              shippingPrice: 10,
              deliveryDate: "10 Nov. at 4 pm",
              onChange: () {},
            ),
            VoucherCard(controller: voucherController, onApply: () {}),
            const SizedBox(height: 10),
            CartSummary(subtotal: 34.9, shipping: 10, total: 44.9),
            const SizedBox(height: 10),
            PlaceOrderButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
