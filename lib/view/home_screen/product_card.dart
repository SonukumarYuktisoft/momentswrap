import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class ModernProductCard extends StatelessWidget {
  final String image, title, subtitle, price;
  final String? productId;
  final List<Offer>? offers;
  final void Function()? addToCart;
  final void Function()? onTap;
  final int stock;

  const ModernProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    this.productId,
    this.offers,
    this.addToCart,
    this.onTap,
    required this.stock,
  });

  // Filter valid offers (not expired)
  List<Offer> get validOffers {
    if (offers == null || offers!.isEmpty) return [];
    return offers!.where((offer) => offer.isValid).toList();
  }

  // Get the best offer (highest discount)
  Offer? get bestOffer {
    if (validOffers.isEmpty) return null;
    return validOffers.reduce((best, current) => 
        current.discountPercentage > best.discountPercentage ? current : best);
  }

  // Calculate discounted price
  double get discountedPrice {
    if (bestOffer == null) return _parsePrice(price);
    double originalPrice = _parsePrice(price);
    double discount = (originalPrice * bestOffer!.discountPercentage) / 100;
    return originalPrice - discount;
  }

  double _parsePrice(String priceStr) {
    return double.tryParse(priceStr.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor,
              AppColors.accentColor.withOpacity(0.98),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with modern styling
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: AppColors.backgroundColor,
                    child: image.isNotEmpty 
                        ? Image.network(
                            image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.backgroundColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.backgroundColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'No Image',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.backgroundColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'No Image',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),

                // Product ID Badge
                if (productId != null && productId!.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '#${productId}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),

                // Discount Badge (Only show if valid offers exist)
                if (bestOffer != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red[600]!,
                            Colors.red[400]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${bestOffer!.discountPercentage}% OFF',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Out of Stock Overlay
                if (stock <= 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Low Stock Warning
                if (stock > 0 && stock <= 5)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Only $stock left',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Subtitle
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textColor.withOpacity(0.6),
                      ),
                    ),

                    Spacer(),

                    // Price Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current/Discounted Price
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                bestOffer != null 
                                    ? "₹${discountedPrice.toStringAsFixed(0)}"
                                    : price,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                                // Original Price (crossed out) and savings
                        if (bestOffer != null) ...[
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                price,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Save ₹${(_parsePrice(price) - discountedPrice).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                          ],
                        ),

                    

                        // Offer validity (if available)
                        // if (bestOffer != null) ...[
                        //   SizedBox(height: 2),
                        //   Text(
                        //     'Valid till ${_formatDate(bestOffer!.validTill)}',
                        //     style: TextStyle(
                        //       fontSize: 9,
                        //       color: Colors.orange[700],
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),

                    SizedBox(height: 8),

                    // Add to Cart Button
                    if (stock > 0) ...[
                      Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: addToCart,
                          icon: Icon(
                            Icons.add_shopping_cart_outlined,
                            size: 16,
                            color: AppColors.accentColor,
                          ),
                          label: Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}