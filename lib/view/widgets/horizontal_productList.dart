import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/models/product_models/product_model.dart';
import 'package:Xkart/util/common/auth_utils.dart';
import 'package:Xkart/view/home_screen/product_card.dart';
import 'package:Xkart/controllers/cart_controller/cart_controller.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/view/home_screen/product_detail_screen/product_detail_screen.dart';

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

class ReusableProductSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final String sectionType;
  final VoidCallback? onViewAll;
  final Function(ProductModel)? onProductTap;
  final IconData? titleIcon;
  final bool showViewAll;
  final int maxItems;

  const ReusableProductSection({
    Key? key,
    required this.title,
    required this.products,
    required this.sectionType,
    this.onViewAll,
    this.onProductTap,
    this.titleIcon,
    this.showViewAll = true,
    this.maxItems = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        SizedBox(height: 12),
        _buildProductsList(context),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (titleIcon != null) ...[
              Icon(titleIcon!, color: AppColors.primaryColor, size: 20),
              SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${products.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        if (showViewAll && products.length > maxItems)
          TextButton(
            onPressed: onViewAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                  size: 12,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return Container(
      height: 280,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 0),
        scrollDirection: Axis.horizontal,
        itemCount: products.take(maxItems).length,
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];

          return Container(
            width: 170,
            margin: EdgeInsets.only(bottom: 8),
            child: ReusableProductCard(
              product: product,
              showAddToCart: false,
              onTap: () {
                print('Tapped on ${sectionType} product: ${product.name}');
                print('Product ID: ${product.id}');

                if (onProductTap != null) {
                  onProductTap!(product);
                } else {
                  // Default navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getEmptyStateIcon(), size: 40, color: Colors.grey[400]),
                SizedBox(height: 8),
                Text(
                  _getEmptyStateMessage(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (sectionType.toLowerCase()) {
      case 'similar':
        return Icons.category_outlined;
      case 'discount':
      case 'offer':
        return Icons.local_offer_outlined;
      case 'rating':
        return Icons.star_outline;
      case 'trending':
        return Icons.trending_up_outlined;
      case 'recent':
        return Icons.new_releases_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  String _getEmptyStateMessage() {
    switch (sectionType.toLowerCase()) {
      case 'similar':
        return 'No similar products found';
      case 'discount':
        return 'No discount products available';
      case 'offer':
        return 'No special offers available';
      case 'rating':
        return 'No high-rated products found';
      case 'trending':
        return 'No trending products available';
      case 'recent':
        return 'No recent products available';
      default:
        return 'No products available';
    }
  }
}
