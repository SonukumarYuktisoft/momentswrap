// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
// import 'package:momentswrap/controllers/order_controller/order_controller.dart';
// import 'package:momentswrap/models/product_models/product_model.dart';
// import 'package:momentswrap/util/common/coustom_curve.dart';
// import 'package:momentswrap/util/constants/app_colors.dart';
// import 'package:momentswrap/util/constants/app_sizes.dart';
// import 'package:momentswrap/util/helpers/share_helper.dart';

// class ProductDetailScreen extends StatelessWidget {
//   final ProductModel product;
//   final CartController cartController = Get.put(CartController());
//   final OrderController orderController = Get.put(OrderController());

//   ProductDetailScreen({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final imageUrl = (product.images.isNotEmpty) ? product.images.first : '';

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               // ---------- TOP IMAGE ----------
//               Column(
//                 children: [
//                   ClipPath(
//                     clipper: CustomCurve(),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.4,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             top: 10,
//                             right: 0,
//                             bottom: 10,
//                             left: 0,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(16),
//                               child: Image.network(
//                                 imageUrl,
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.3,
//                                 width: double.infinity,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     color: Colors.grey[300],
//                                     child: const Icon(
//                                       Icons.image_not_supported,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           // back button
//                           Positioned(
//                             top: 16,
//                             left: 16,
//                             child: CircleAvatar(
//                               backgroundColor: Colors.white,
//                               child: IconButton(
//                                 icon: const Icon(Icons.arrow_back),
//                                 onPressed: () => Get.back(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // ---------- DETAILS ---------- (Fixed with Flexible and SingleChildScrollView)
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSizes.defaultSpacing,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product name with overflow handling
//                     Text(
//                       product.name ?? "No Name",
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                     ),
//                     const SizedBox(height: 8),

//                     // Price and share row with proper flex
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "₹${product.price ?? 0}",
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.share_rounded),
//                           onPressed: () {
//                             ShareHelper.shareProduct(
//                               name: product.name ?? "",
//                               price: product.price?.toString() ?? "0",
//                               imageUrl: imageUrl,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // Description section
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),

//                     // Short description with proper text wrapping
//                     Text(
//                       product.shortDescription ?? "No description available",
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                       textAlign: TextAlign.justify,
//                     ),
//                     const SizedBox(height: 8),

//                     // Long description with proper text wrapping
//                     Text(
//                       product.longDescription ?? "No description available",
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                       textAlign: TextAlign.justify,
//                     ),

//                     const SizedBox(height: 16),

//                     // Cart controls with proper spacing
//                     // Obx(
//                     //   () => Row(
//                     //     mainAxisSize: MainAxisSize.min,
//                     //     children: [
//                     //       IconButton(
//                     //         onPressed: cartController.addItems,
//                     //         icon: const Icon(Icons.add_circle_outline),
//                     //       ),
//                     //       Container(
//                     //         padding: const EdgeInsets.symmetric(horizontal: 8),
//                     //         child: Text(
//                     //           "${cartController.itemCount.value}",
//                     //           style: const TextStyle(fontSize: 18),
//                     //         ),
//                     //       ),
//                     //       cartController.itemCount.value == 1
//                     //           ? IconButton(
//                     //               onPressed: () => cartController
//                     //                   .removeFromCart(product.id ?? ""),
//                     //               icon: const Icon(Icons.delete_forever),
//                     //             )
//                     //           : IconButton(
//                     //               onPressed: cartController.removeItems,
//                     //               icon: const Icon(Icons.remove_circle_outline),
//                     //             ),
//                     //     ],
//                     //   ),
//                     // ),

//                     const SizedBox(height: 24),

//                     // ---------- ACTION BUTTONS ---------- (Fixed with proper constraints)
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Obx(() {
//                             return ElevatedButton.icon(
//                               onPressed: () {
//                                 cartController.addToCart(
//                                   image: imageUrl,
//                                   productId: product.id,
//                                   quantity: 1,
//                                   totalPrice: product.price.toDouble(),
//                                 );
//                               },
//                               icon: const Icon(Icons.shopping_cart, size: 20),
//                               label: cartController.isAddCartLoading.value
//                                   ? CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: AppColors.secondaryColor,
//                                     )
//                                   : Text(
//                                       "Add to Cart",
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                               style: ElevatedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(width: 16),
//                         Obx(() {
//                           return Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 orderController.buyProduct(
//                                   productId: product.id,
//                                   // quantity: cartController.itemCount.value,
//                                   quantity: 1,
//                                 );
//                                 print("buy now");
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.pink,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: orderController.isBuyProductLoading.value
//                                   ? CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: AppColors.secondaryColor,
//                                     )
//                                   : Text(
//                                       "Buy Now",
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                             ),
//                           );
//                         }),
//                       ],
//                     ),

//                     // Add some bottom padding for better UX
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/helpers/share_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final PageController pageController = PageController();
  int currentImageIndex = 0;

  // Filter valid offers (not expired)
  List<Offer> get validOffers {
    return widget.product.offers
        .where((offer) => offer.validTill.isAfter(DateTime.now()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasValidImages = widget.product.images.isNotEmpty;
    final displayImages = hasValidImages ? widget.product.images : [''];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Image Carousel
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.secondaryColor,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    color: AppColors.secondaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    ShareHelper.shareProduct(
                      name: widget.product.name ?? "",
                      price: widget.product.price?.toString() ?? "0",
                      imageUrl: hasValidImages? widget.product.images.first: "",
                      shareUrl: 'https://moment-wrap-frontend.vercel.app/product/${widget.product.id}',
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Image Carousel
                    PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                      itemCount: displayImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: hasValidImages
                                ? Image.network(
                                    displayImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderImage();
                                    },
                                  )
                                : _buildPlaceholderImage(),
                          ),
                        );
                      },
                    ),

                    // Page Indicator
                    if (displayImages.length > 1)
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SmoothPageIndicator(
                              controller: pageController,
                              count: displayImages.length,
                              effect: WormEffect(
                                dotColor: Colors.white.withOpacity(0.5),
                                activeDotColor: AppColors.accentColor,
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Product Details Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Header
                    _buildProductHeader(),
                    SizedBox(height: 20),

                    // Rating Section
                    _buildRatingSection(),
                    SizedBox(height: 20),

                    // Valid Offers Section
                    if (validOffers.isNotEmpty) ...[
                      _buildOffersSection(),
                      SizedBox(height: 20),
                    ],

                    // Technical Specifications
                    if (widget.product.technicalSpecifications.isNotEmpty) ...[
                      _buildSpecificationsSection(),
                      SizedBox(height: 20),
                    ],

                    // Description Section
                    _buildDescriptionSection(),
                    SizedBox(height: 20),

                    // Stock Status
                    _buildStockStatus(),
                    SizedBox(height: 20),

                    // Material & Warranty Info
                    _buildProductInfo(),
                    SizedBox(height: 20),

                    // Reviews Section
                    if (widget.product.reviews.isNotEmpty) ...[
                      _buildReviewsSection(),
                      SizedBox(height: 20),
                    ],

                    // Action Buttons
                    // _buildActionButtons(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:   SafeArea(child: _buildActionButtons()),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.backgroundColor,
      child: Icon(Icons.image_outlined, size: 80, color: Colors.grey[400]),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product ID Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ID: ${widget.product.productId}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 12),

              Text(
                widget.product.name ?? "No Name",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),

              Text(
                widget.product.category ?? "Uncategorized",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "₹${widget.product.price ?? 0}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              color: AppColors.primaryColor,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: 24),
          SizedBox(width: 8),
          // RatingBarIndicator(
          //   rating: widget.product.averageRating,
          //   itemBuilder: (context, index) => Icon(
          //     Icons.star_rounded,
          //     color: Colors.amber,
          //   ),
          //   itemCount: 5,
          //   itemSize: 20.0,
          // ),
          SizedBox(width: 12),
          Text(
            '${widget.product.averageRating.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '(${widget.product.reviews.length} reviews)',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_offer_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Available Offers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...validOffers
            .map(
              (offer) => Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${offer.discountPercentage}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.offerTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                          if (offer.offerDescription.isNotEmpty)
                            Text(
                              offer.offerDescription,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          Text(
                            'Valid till ${_formatDate(offer.validTill)}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildSpecificationsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Specifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...widget.product.technicalSpecifications
              .map(
                (spec) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          spec.specName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Text(
                        ': ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          spec.specValue,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.product.shortDescription ?? "No description available",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          if (widget.product.longDescription != null &&
              widget.product.longDescription!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              widget.product.longDescription!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
          if (widget.product.usageInstructions.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(
              'Usage Instructions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.product.usageInstructions,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockStatus() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.product.stock > 0
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.product.stock > 0
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.product.stock > 0
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            color: widget.product.stock > 0
                ? Colors.green[700]
                : Colors.red[700],
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.stock > 0 ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.product.stock > 0
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontSize: 14,
                  ),
                ),
                if (widget.product.stock > 0)
                  Text(
                    '${widget.product.stock} items available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
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

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Product Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow('Material', widget.product.material),
          _buildInfoRow('Warranty', widget.product.warranty),
          _buildInfoRow('Shop', widget.product.shop),
          if (widget.product.saleFor.isNotEmpty)
            _buildInfoRow('Suitable For', widget.product.saleFor.join(', ')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rate_review_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Reviews (${widget.product.reviews.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...widget.product.reviews
            .take(3)
            .map(
              (review) => Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.customer,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // RatingBarIndicator(
                        //   rating: review.rating.toDouble(),
                        //   itemBuilder: (context, index) => Icon(
                        //     Icons.star_rounded,
                        //     color: Colors.amber,
                        //   ),
                        //   itemCount: 5,
                        //   itemSize: 16.0,
                        // ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (widget.product.stock <= 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Out of Stock',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Add to Cart Button
          Expanded(
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: cartController.isAddCartLoading.value
                      ? null
                      : () {
                          AuthUtils.runIfLoggedIn(() {
                            cartController.addToCart(
                              image: widget.product.images.isNotEmpty
                                  ? widget.product.images.first
                                  : '',
                              productId: widget.product.id,
                              quantity: 1,
                              totalPrice: widget.product.price.toDouble(),
                            );
                          });
                        },
                  icon: cartController.isAddCartLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accentColor,
                          ),
                        )
                      : Icon(
                          Icons.shopping_cart_outlined,
                          size: 20,
                          color: AppColors.accentColor,
                        ),
                  label: Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            }),
          ),
      
          const SizedBox(width: 16),
      
          // Buy Now Button
          Expanded(
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: orderController.isBuyProductLoading.value
                      ? null
                      : () {
                          AuthUtils.runIfLoggedInAndHasAddress(() {
                            orderController.buyProduct(
                              productId: widget.product.id,
                              quantity: 1,
                            );
                          });
                        },
                  icon: orderController.isBuyProductLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accentColor,
                          ),
                        )
                      : Icon(
                          Icons.flash_on_outlined,
                          size: 20,
                          color: AppColors.accentColor,
                        ),
                  label: Text(
                    "Buy Now",
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.accentColor,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
