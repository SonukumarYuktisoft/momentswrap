import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/view/home_screen/product_detail_screen.dart';

class ModernProductCard extends StatelessWidget {
  final String image, title, subtitle, price;
  final String? productId;
  final List<Offer>? offers;
  final void Function()? addToCart;
  final void Function()? onTap;
  final int stock;
  final showAddToCart;

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
    this.showAddToCart = false,
  });

  // Filter valid offers (not expired)
  List<Offer> get validOffers {
    if (offers == null || offers!.isEmpty) return [];
    return offers!.where((offer) => offer.isValid).toList();
  }

  // Get the best offer (highest discount)
  Offer? get bestOffer {
    if (validOffers.isEmpty) return null;
    return validOffers.reduce(
      (best, current) =>
          current.discountPercentage > best.discountPercentage ? current : best,
    );
  }

  // Calculate discounted price
  double get discountedPrice {
    if (bestOffer == null) return _parsePrice(price);
    double originalPrice = _parsePrice(price);
    double discount = (originalPrice * bestOffer!.discountPercentage) / 100;
    return originalPrice - discount;
  }

  double _parsePrice(String priceStr) {
    return double.tryParse(priceStr.replaceAll('₹', '').replaceAll(',', '')) ??
        0.0;
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
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
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
                          colors: [Colors.red[600]!, Colors.red[400]!],
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
                      showAddToCart
                          ? Container(
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
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
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
                            )
                          : SizedBox.shrink(),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class ReusableProductCard extends StatelessWidget {
  final ProductModel product;
  final bool showAddToCart;
  final bool compactView;
  final double? cardWidth;
  final double? cardHeight;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const ReusableProductCard({
    super.key,
    required this.product,
    this.showAddToCart = true,
    this.compactView = false,
    this.cardWidth,
    this.cardHeight,
    this.onTap,
    this.padding,
    this.borderRadius,
  });

  // Get valid offers (not expired)
  List<Offer> get validOffers {
    return product.offers
        .where((offer) => offer.validTill.isAfter(DateTime.now()))
        .toList();
  }

  // Get best offer (highest discount)
  Offer? get bestOffer {
    if (validOffers.isEmpty) return null;
    return validOffers.reduce(
      (best, current) => current.discountPercentage > best.discountPercentage 
          ? current 
          : best,
    );
  }

  // Calculate discounted price with validation
  double get discountedPrice {
    if (bestOffer == null) return product.price;
    
    double originalPrice = product.price;
    double discountAmount = (originalPrice * bestOffer!.discountPercentage) / 100;
    double finalPrice = originalPrice - discountAmount;
    
    // Validation: ensure discounted price is not negative or unrealistic
    if (finalPrice < 0 || finalPrice >= originalPrice) {
      return originalPrice;
    }
    
    return finalPrice;
  }

  // Calculate savings amount
  double get savingsAmount {
    return product.price - discountedPrice;
  }

  // Check if product has valid discount
  bool get hasValidDiscount {
    return bestOffer != null && savingsAmount > 0;
  }

  // Default navigation method
  void _navigateToProductDetail() {
    if (onTap != null) {
      onTap!();
    } else {
      // Fallback navigation
      Get.to(
        () => ProductDetailScreen(product: product),
        preventDuplicates: false,
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _navigateToProductDetail,
        borderRadius: borderRadius ?? BorderRadius.circular(compactView ? 12 : 16),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          padding: padding,
          constraints: BoxConstraints(
            minHeight: compactView ? 200 : 280,
            minWidth: 150,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accentColor,
                AppColors.accentColor.withOpacity(0.98),
              ],
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(compactView ? 12 : 16),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Section
              _buildImageSection(),
              
              // Content Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(compactView ? 8 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Info Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title
                          _buildProductTitle(),
                          
                          SizedBox(height: compactView ? 2 : 4),
                          
                          // Category and Rating
                          if (!compactView) _buildCategoryAndRating(),
                        ],
                      ),
                      
                      // Price and Action Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price Section
                          _buildPriceSection(),
                          
                          SizedBox(height: compactView ? 4 : 8),
                          
                          // Action Button
                          if (showAddToCart) _buildActionButton(cartController),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Main Image Container with fixed height
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(compactView ? 12 : 16),
          ),
          child: Container(
            height: compactView ? 100 : 140,
            width: double.infinity,
            color: AppColors.backgroundColor,
            child: product.images.isNotEmpty
                ? Image.network(
                    product.images.first,
                    height: compactView ? 100 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImagePlaceholder(isLoading: true);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder();
                    },
                  )
                : _buildImagePlaceholder(),
          ),
        ),

        // Badges and Overlays
        _buildImageOverlays(),
      ],
    );
  }

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Container(
      height: compactView ? 100 : 140,
      width: double.infinity,
      color: AppColors.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            )
          else ...[
            Icon(
              Icons.image_outlined,
              size: compactView ? 30 : 40,
              color: Colors.grey[400],
            ),
            SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: compactView ? 8 : 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageOverlays() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Discount Badge
          if (hasValidDiscount)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compactView ? 6 : 8,
                  vertical: compactView ? 2 : 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[400]!],
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
                    fontSize: compactView ? 8 : 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Out of Stock Overlay
          if (product.stock <= 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(compactView ? 12 : 16),
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'OUT OF STOCK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compactView ? 9 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Low Stock Warning
          if (product.stock > 0 && product.stock <= 5)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Only ${product.stock} left',
                  style: TextStyle(
                    fontSize: compactView ? 7 : 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    return Text(
      product.name,
      maxLines: compactView ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: compactView ? 12 : 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
        height: 1.2,
      ),
    );
  }

  Widget _buildCategoryAndRating() {
    return Row(
      children: [
        Expanded(
          child: Text(
            product.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textColor.withOpacity(0.6),
            ),
          ),
        ),
        if (product.averageRating > 0) ...[
          Icon(
            Icons.star_rounded,
            size: 12,
            color: Colors.amber,
          ),
          SizedBox(width: 2),
          Text(
            product.averageRating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current Price
        Text(
          hasValidDiscount 
              ? "₹${discountedPrice.toStringAsFixed(0)}"
              : "₹${product.price.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: compactView ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        
        // Original Price and Savings
        if (hasValidDiscount) ...[
          SizedBox(height: 2),
          Wrap(
            spacing: 6,
            children: [
              Text(
                "₹${product.price.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: compactView ? 10 : 12,
                  color: Colors.grey[600],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                'Save ₹${savingsAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: compactView ? 9 : 10,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(CartController cartController) {
    if (product.stock <= 0) {
      return SizedBox(
        width: double.infinity,
        height: compactView ? 32 : 36,
        child: Container(
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
                fontSize: compactView ? 10 : 12,
              ),
            ),
          ),
        ),
      );
    }

    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: compactView ? 32 : 36,
        child: ElevatedButton.icon(
          onPressed: cartController.isAddCartLoading.value
              ? null
              : () {
                  AuthUtils.runIfLoggedIn(() async {
                    await cartController.addToCart(
                      productId: product.id,
                      quantity: 1,
                      image: product.images.isNotEmpty 
                          ? product.images.first 
                          : '',
                      totalPrice: hasValidDiscount 
                          ? discountedPrice 
                          : product.price,
                    );
                  });
                },
          icon: cartController.isAddCartLoading.value
              ? SizedBox(
                  width: compactView ? 12 : 16,
                  height: compactView ? 12 : 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accentColor,
                  ),
                )
              : Icon(
                  Icons.add_shopping_cart_outlined,
                  size: compactView ? 12 : 16,
                  color: AppColors.accentColor,
                ),
          label: Text(
            "Add to Cart",
            style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.w600,
              fontSize: compactView ? 10 : 12,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: compactView ? 6 : 8),
            elevation: 2,
          ),
        ),
      );
    });
  }
}