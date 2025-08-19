import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/coustom_curve.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/helpers/share_helper.dart';
import 'package:momentswrap/view/add_to_cart_screen/add_to_cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.put(CartController());

  ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.image?.isNotEmpty ?? false)
        ? product.image!.first
        : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- TOP IMAGE ----------
            ClipPath(
              clipper: CustomCurve(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,

                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),

                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 0,
                      bottom: 10,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // back button
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),

                    // share button
                  ],
                ),
              ),
            ),

            // ---------- DETAILS ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "No Name",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${product.price ?? 0}",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          onPressed: () {
                            ShareHelper.shareProduct(
                              name: product.name ?? "",
                              price: product.price?.toString() ?? "0",
                              imageUrl: imageUrl,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.shortDescription ?? "No description available",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      product.longDescription ?? "No description available",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          cartController.removeFromCart(product.id ?? ""),
                      child: Text('Remove from cart'),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: cartController.addItems,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          Text(
                            "${cartController.itemCount.value}", // realtime update
                            style: const TextStyle(fontSize: 18),
                          ),
                          cartController.itemCount.value == 1
                              ? IconButton(
                                  onPressed: () => cartController
                                      .removeFromCart(product.id ?? ""),
                                  icon: Icon(Icons.delete_forever),
                                )
                              : IconButton(
                                  onPressed: cartController.removeItems,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ---------- ACTION BUTTONS ----------
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            // final isInCart = cartController.cartItems.any(
                            //   (item) => item.product == product.id,
                            // );
                            return ElevatedButton.icon(
                              onPressed: () {
                                //        cartController.addToCart(
                                //   productId:product.id ?? '',
                                //   quantity: cartController.itemCount.value,
                                //   image: product.image?.first ?? '',
                                //   price: product.price!.toDouble(),
                                // );
                                cartController.cartItems.add(product);
                              },
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Add to Cart"),
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: isInCart
                                //     ? Colors.green
                                //     : AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Buy Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
