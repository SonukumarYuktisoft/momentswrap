import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/coustom_curve.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/helpers/share_helper.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());

  ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.images.isNotEmpty) ? product.images.first : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // ---------- TOP IMAGE ----------
              Column(
                children: [
                  ClipPath(
                    clipper: CustomCurve(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ---------- DETAILS ---------- (Fixed with Flexible and SingleChildScrollView)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.defaultSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name with overflow handling
                    Text(
                      product.name ?? "No Name",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),

                    // Price and share row with proper flex
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "₹${product.price ?? 0}",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
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

                    // Description section
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Short description with proper text wrapping
                    Text(
                      product.shortDescription ?? "No description available",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8),

                    // Long description with proper text wrapping
                    Text(
                      product.longDescription ?? "No description available",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 16),

                    // Cart controls with proper spacing
                    Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: cartController.addItems,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "${cartController.itemCount.value}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          cartController.itemCount.value == 1
                              ? IconButton(
                                  onPressed: () => cartController
                                      .removeFromCart(product.id ?? ""),
                                  icon: const Icon(Icons.delete_forever),
                                )
                              : IconButton(
                                  onPressed: cartController.removeItems,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------- ACTION BUTTONS ---------- (Fixed with proper constraints)
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return ElevatedButton.icon(
                              onPressed: () {
                                cartController.addToCart(
                                  image: imageUrl,
                                  productId: product.id,
                                  quantity: cartController.itemCount.value,
                                  totalPrice: product.price.toDouble(),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart, size: 20),
                              label: cartController.isAddCartLoading.value
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.secondaryColor,
                                    )
                                  : Text(
                                      "Add to Cart",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              style: ElevatedButton.styleFrom(
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
                        Obx(() {
                          return Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                orderController.buyProduct(
                                  productId: product.id,
                                  quantity: cartController.itemCount.value,
                                );
                                print("buy now");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: orderController.isBuyProductLoading.value ?CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.secondaryColor,
                                    ):  Text(
                                "Buy Now",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    // Add some bottom padding for better UX
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
