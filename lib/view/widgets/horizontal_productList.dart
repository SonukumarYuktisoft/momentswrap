import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/view/home_screen/product_card.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class HorizontalProductList extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final VoidCallback onSeeAll;
  final Function(ProductModel) onProductTap;

  const HorizontalProductList({
    super.key,
    required this.title,
    required this.products,
    required this.onSeeAll,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return SizedBox();

    final CartController cartController = Get.find<CartController>();
    final displayProducts = products.length > 10
        ? products.sublist(0, 10)
        : products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + See All Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal scrollable product list
        Container(
          height: 280, // Increased height for better card visibility
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 0),
            scrollDirection: Axis.horizontal,
            itemCount: displayProducts.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = displayProducts[index];

              return GestureDetector(
                onTap: () {
                  // Fixed navigation - properly call the onProductTap function
                  onProductTap(product);
                },
                child: Container(
                  width: 170, // Fixed width for cards
                  margin: EdgeInsets.only(
                    bottom: 8,
                  ), // Add bottom margin for shadow
                  child: ModernProductCard(
                    image: product.images.isNotEmpty
                        ? product.images.first
                        : '',
                    title: product.name,
                    subtitle: product.shortDescription,
                    price: "₹${product.price}",
                    offers: product.offers,
                    stock: product.stock,
                    showAddToCart:
                        false, // Don't show add to cart in horizontal list
                    // addToCart: () {
                    //   // Optional: Add to cart functionality
                    //   AuthUtils.runIfLoggedIn(() async {
                    //     await cartController.addToCart(
                    //       productId: product.id,
                    //       quantity: 1,
                    //       image: product.images.isNotEmpty
                    //           ? product.images.first
                    //           : '',
                    //       totalPrice: product.price.toDouble(),
                    //     );
                    //   });
                    // },
                    onTap: () {
                      // Ensure tap navigation works properly
                      onProductTap(product);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
