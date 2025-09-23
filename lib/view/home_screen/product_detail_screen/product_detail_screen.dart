import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/controllers/order_controller/place_order_controller.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/util/common/auth_utils.dart';
import 'package:Xkart/view/home_screen/product_card.dart';
import 'package:Xkart/view/home_screen/product_detail_screen/widgets/full_screenImage_viewer.dart';
import 'package:Xkart/view/reviews_screen/reviews_screen.dart';
import 'package:Xkart/reviews_screen/reviews_screen.dart';
import 'package:Xkart/view/search_screens/search_screen.dart';
import 'package:Xkart/view/widgets/all_products_screen.dart';
import 'package:Xkart/view/widgets/horizontal_productList.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:Xkart/controllers/cart_controller/cart_controller.dart';
import 'package:Xkart/controllers/order_controller/order_controller.dart';
import 'package:Xkart/controllers/product_controller/product_controller.dart';
import 'package:Xkart/models/product_models/product_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/util/constants/app_sizes.dart';
import 'package:Xkart/util/helpers/share_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final PlaceOrderController placeOrderController = Get.put(
    PlaceOrderController(),
  );
  final ProductController productController = Get.find<ProductController>();
  final PageController pageController = PageController();
  int currentImageIndex = 0;

  // Filter valid offers (not expired)
  List<Offer> get validOffers {
    return widget.product.offers
        .where((offer) => offer.validTill.isAfter(DateTime.now()))
        .toList();
  }

  // Get similar products (same category)
  List<ProductModel> get similarProducts {
    return productController.productsList
        .where(
          (p) =>
              p.category == widget.product.category &&
              p.id != widget.product.id &&
              p.isActive,
        )
        .take(10)
        .toList();
  }

  // Get discount products (products with offers)
  List<ProductModel> get discountProducts {
    return productController.productsList
        .where(
          (p) =>
              p.offers.any(
                (offer) => offer.validTill.isAfter(DateTime.now()),
              ) &&
              p.id != widget.product.id &&
              p.isActive,
        )
        .take(10)
        .toList();
  }

  // Get high rating products (rating > 4)
  List<ProductModel> get highRatingProducts {
    return productController.productsList
        .where(
          (p) =>
              p.averageRating >= 4.0 && p.id != widget.product.id && p.isActive,
        )
        .take(10)
        .toList();
  }

  // Get special offer products
  List<ProductModel> get specialOfferProducts {
    return productController.productsList
        .where(
          (p) => p.offers.isNotEmpty && p.id != widget.product.id && p.isActive,
        )
        .take(10)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasValidImages = widget.product.images.isNotEmpty;
    final displayImages = hasValidImages ? widget.product.images : [''];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          // 🔍 Search Icon
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textColor),
            onPressed: () {
              Get.toNamed(AppRoutes.searchScreen);
            },
          ),

          // 🛒 Cart Icon with Badge
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() {
              final itemCount = cartController.totalItems;
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: AppColors.textColor),
                    onPressed: () {
                      Get.toNamed(AppRoutes.cartScreen);
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar with Image Carousel
            _buildImageCarousel(),

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
                      Row(
                        children: [
                          _buildRatingSection(),
                          SizedBox(width: 10),
                          // Stock Status
                          _buildStockStatus(),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Valid Offers Section
                      if (validOffers.isNotEmpty) ...[
                        _buildOffersSection(),
                        SizedBox(height: 20),
                      ],

                      // Technical Specifications
                      if (widget
                          .product
                          .technicalSpecifications
                          .isNotEmpty) ...[
                        _buildSpecificationsSection(),
                        SizedBox(height: 20),
                      ],

                      // Description Section
                      _buildDescriptionSection(),
                      SizedBox(height: 20),

                      // // Stock Status
                      // _buildStockStatus(),
                      // SizedBox(height: 20),

                      // Material & Warranty Info
                      _buildProductInfo(),
                      SizedBox(height: 20),
                      // Reviews Section
                      _buildReviewsSection(),
                      SizedBox(height: 20),

                      Column(
                        children: [
                          if (similarProducts.isNotEmpty)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Similar Products',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _navigateToAllProducts('similar');
                                        },
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 280,
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: similarProducts.take(5).length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                      final similarProduct =
                                          similarProducts[index];

                                      return Container(
                                        width: 170,
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: ReusableProductCard(
                                          product: similarProduct,
                                          showAddToCart: false,
                                          onTap: () {
                                            print(
                                              'Tapped on similar product: ${similarProduct.name}',
                                            );
                                            print(
                                              'Product ID: ${similarProduct.id}',
                                            );

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailScreen(
                                                      product: similarProduct,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceTint,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No similar products found',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Special Offer Products Section
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Special Offer Products',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _navigateToAllProducts('offer');
                                      },
                                      child: Text(
                                        'View All',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 280,
                                child: ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productController
                                      .getSpecialOfferProducts()
                                      .take(10)
                                      .length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final specialOfferProduct =
                                        specialOfferProducts[index];

                                    return Container(
                                      width: 170,
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ReusableProductCard(
                                        product: specialOfferProduct,
                                        showAddToCart: false,
                                        onTap: () {
                                          print(
                                            'Tapped on similar product: ${specialOfferProduct.name}',
                                          );
                                          print(
                                            'Product ID: ${specialOfferProduct.id}',
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                    product:
                                                        specialOfferProduct,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Discount Products Section
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'discount Products',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _navigateToAllProducts('discount');
                                      },
                                      child: Text(
                                        'View All',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 280,
                                child: ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: discountProducts.take(10).length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final discountProduct =
                                        discountProducts[index];

                                    return Container(
                                      width: 170,
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ReusableProductCard(
                                        product: discountProduct,
                                        showAddToCart: false,
                                        onTap: () {
                                          print(
                                            'Tapped on similar product: ${discountProduct.name}',
                                          );
                                          print(
                                            'Product ID: ${discountProduct.id}',
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                    product: discountProduct,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          // High Rating Products Section
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'High Rating Products',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _navigateToAllProducts('high_rating');
                                      },
                                      child: Text(
                                        'View All',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 280,
                                child: ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productController
                                      .getHighRatingProducts()
                                      .take(10)
                                      .length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final highRatingProduct = productController
                                        .getHighRatingProducts()[index];

                                    return Container(
                                      width: 170,
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ReusableProductCard(
                                        product: highRatingProduct,
                                        showAddToCart: false,
                                        onTap: () {
                                          print(
                                            'Tapped on high rating product: ${highRatingProduct.name}',
                                          );
                                          print(
                                            'Product ID: ${highRatingProduct.id}',
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(
                                                    product: highRatingProduct,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: _buildActionButtons()),
    );
  }

  // Widget _buildImageCarousel() {
  //   final images = widget.product.images.isNotEmpty ? widget.product.images : [''];
  //   final hasValidImages = widget.product.images.isNotEmpty;

  //   return SliverToBoxAdapter(
  //     child: Container(
  //       height: MediaQuery.of(context).size.height * 0.5,
  //       color: Colors.grey[100],
  //       child: Stack(
  //         children: [
  //           PageView.builder(
  //             controller: pageController,
  //             onPageChanged: (index) => setState(() => currentImageIndex = index),
  //             itemCount: images.length,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 padding: EdgeInsets.all(20),
  //                 child: hasValidImages
  //                     ? Image.network(
  //                         images[index],
  //                         fit: BoxFit.contain,
  //                         errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
  //                       )
  //                     : _buildPlaceholderImage(),
  //               );
  //             },
  //           ),

  //           // Actions
  //           Positioned(
  //             top: 20,
  //             right: 20,
  //             child: Column(
  //               children: [
  //                 // _buildActionButton(Icons.favorite_border, () {}),
  //                 SizedBox(height: 12),
  //                 IconButton(
  //                   icon: Icon(Icons.share_outlined, color: Colors.black),
  //                   onPressed: () {
  //                     ShareHelper.shareProduct(
  //                       name: widget.product.name,
  //                       price: widget.product.price.toString(),
  //                       imageUrl: hasValidImages ? widget.product.images.first : "",
  //                       shareUrl: 'https://moment-wrap-frontend.vercel.app/product/${widget.product.id}',
  //                     );
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),

  //           // Page Indicators
  //           if (images.length > 1)
  //             Positioned(
  //               bottom: 20,
  //               left: 0,
  //               right: 0,
  //               child: Center(
  //                 child: SmoothPageIndicator(
  //                   controller: pageController,
  //                   count: images.length,
  //                   effect: WormEffect(
  //                     dotColor: Colors.grey[300]!,
  //                     activeDotColor: AppColors.primaryColor,
  //                     dotHeight: 8,
  //                     dotWidth: 8,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildImageCarousel() {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [''];
    final hasValidImages = widget.product.images.isNotEmpty;

    return SliverToBoxAdapter(
      child: Container(
        height:
            MediaQuery.of(context).size.height *
            0.6, // Increased height for thumbnails
        color: Colors.grey[100],
        child: Column(
          children: [
            // Main Image Section
            Expanded(
              child: Stack(
                children: [
                  // Main Image PageView
                  PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) =>
                        setState(() => currentImageIndex = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _openFullScreenImage(images, index),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: hasValidImages
                              ? Hero(
                                  tag: 'product_image_$index',
                                  child: Image.network(
                                    images[index],
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) =>
                                        _buildPlaceholderImage(),
                                  ),
                                )
                              : _buildPlaceholderImage(),
                        ),
                      );
                    },
                  ),

                  // Actions (Top Right)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Column(
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.white.withOpacity(0.9),
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.favorite_border,
                        //       color: Colors.black,
                        //     ),
                        //     onPressed: () {
                        //       // Add to favorites functionality
                        //     },
                        //   ),
                        // ),
                        SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.share_outlined,
                              color: AppColors.primaryForegroundColor,
                            ),
                            onPressed: () {
                              ShareHelper.shareProduct(
                                name: widget.product.name,
                                price: widget.product.price.toString(),
                                imageUrl: hasValidImages
                                    ? widget.product.images.first
                                    : "",
                                shareUrl:
                                    'https://moment-wrap-frontend.vercel.app/product/${widget.product.id}',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Page Indicators (only if no thumbnails or single image)
                  if (images.length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: images.length,
                          effect: WormEffect(
                            dotColor: Colors.grey[300]!,
                            activeDotColor: AppColors.primaryColor,
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Thumbnail Section (only show if more than 1 image)
            if (images.length > 1)
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final isSelected = currentImageIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => currentImageIndex = index);
                        pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: hasValidImages
                              ? Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Full Screen Image Viewer
  void _openFullScreenImage(List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImageViewer(images: images, initialIndex: initialIndex),
      ),
    );
  }

  // Navigation Methods
  void _navigateToAllProducts(String type) {
    List<ProductModel> products = [];
    String title = '';

    switch (type) {
      case 'similar':
        products = productController.productsList
            .where(
              (p) =>
                  p.category == widget.product.category &&
                  p.id != widget.product.id &&
                  p.isActive,
            )
            .toList();
        title = 'Similar Products';
        break;
      case 'discount':
        products = productController.productsList
            .where(
              (p) =>
                  p.offers.any(
                    (offer) => offer.validTill.isAfter(DateTime.now()),
                  ) &&
                  p.id != widget.product.id &&
                  p.isActive,
            )
            .toList();
        title = 'Discount Products';
        break;
      case 'high_rating':
        products = productController.productsList
            .where(
              (p) =>
                  p.averageRating >= 4.0 &&
                  p.id != widget.product.id &&
                  p.isActive,
            )
            .toList();
        title = 'Top Rated Products';
        break;
      case 'offer':
        products = productController.productsList
            .where(
              (p) =>
                  p.offers.isNotEmpty &&
                  p.id != widget.product.id &&
                  p.isActive,
            )
            .toList();
        title = 'Special Offers';
        break;
    }

    Get.to(
      () => AllProductsPage(
        title: title,
        products: products,
        onProductTap: _navigateToProductDetail,
      ),
    );
  }

  void _navigateToProductDetail(ProductModel product) {
    Get.to(() => ProductDetailScreen(product: product));
  }

  void _navigateToReviews() {
    Get.to(
      () => ReviewsScreen(
        productId: widget.product.id,
        productName: widget.product.name,
      ),
    );
  }

  // Rest of the widget methods remain the same...
  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.backgroundColor,
      child: Icon(Icons.image_outlined, size: 80, color: Colors.grey[400]),
    );
  }

  // Widget _buildProductHeader() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // // Product ID Badge
  //             // Container(
  //             //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             //   decoration: BoxDecoration(
  //             //     color: AppColors.primaryLight,
  //             //     borderRadius: BorderRadius.circular(20),
  //             //   ),
  //             //   child: Text(
  //             //     'ID: ${widget.product.productId}',
  //             //     style: TextStyle(
  //             //       fontSize: 12,
  //             //       fontWeight: FontWeight.w600,
  //             //       color: AppColors.primaryColor,
  //             //     ),
  //             //   ),
  //             // ),
  //             SizedBox(height: 12),

  //             Text(
  //               widget.product.name ?? "No Name",
  //               style: TextStyle(
  //                 fontSize: 26,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.textColor,
  //                 height: 1.2,
  //               ),
  //             ),
  //             SizedBox(height: 8),

  //             Text(
  //               widget.product.category ?? "Uncategorized",
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: AppColors.textSecondary,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             SizedBox(height: 12),

  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //               decoration: BoxDecoration(
  //                 gradient: AppColors.primaryGradient,
  //                 borderRadius: BorderRadius.circular(25),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: AppColors.primaryColor.withOpacity(0.3),
  //                     blurRadius: 8,
  //                     offset: Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Text(
  //                 "₹${widget.product.price ?? 0}",
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.accentColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: AppColors.primaryLight,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: IconButton(
  //           onPressed: () {},
  //           icon: Icon(
  //             Icons.favorite_border,
  //             color: AppColors.primaryColor,
  //             size: 24,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Add these getter methods to your _ProductDetailScreenState class

  // Get best offer (highest discount)
  Offer? get bestOffer {
    if (validOffers.isEmpty) return null;
    return validOffers.reduce(
      (best, current) =>
          current.discountPercentage > best.discountPercentage ? current : best,
    );
  }

  // Calculate discounted price with validation
  double get discountedPrice {
    if (bestOffer == null) return widget.product.price;

    double originalPrice = widget.product.price;
    double discountAmount =
        (originalPrice * bestOffer!.discountPercentage) / 100;
    double finalPrice = originalPrice - discountAmount;

    // Validation: ensure discounted price is not negative or unrealistic
    if (finalPrice < 0 || finalPrice >= originalPrice) {
      return originalPrice;
    }

    return finalPrice;
  }

  // Calculate savings amount
  double get savingsAmount {
    return widget.product.price - discountedPrice;
  }

  // Check if product has valid discount
  bool get hasValidDiscount {
    return bestOffer != null && savingsAmount > 0;
  }

  // Updated _buildProductHeader method with discount logic
  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Price Section with Discount Logic
              _buildPriceSection(),
            ],
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: AppColors.primaryLight,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.favorite_border,
        //       color: AppColors.primaryColor,
        //       size: 24,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // New price section widget with discount calculations
  Widget _buildPriceSection() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        // gradient: AppColors.primaryGradient,
        // borderRadius: BorderRadius.circular(25),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primaryColor.withOpacity(0.3),
        //     blurRadius: 8,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // // Current/Discounted Price
          // Text(
          //   hasValidDiscount
          //       ? "₹${discountedPrice.toStringAsFixed(0)}"
          //       : "₹${widget.product.price.toStringAsFixed(0)}",
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //     color: AppColors.accentColor,
          //   ),
          // ),

          // Original Price and Savings (if discount exists)
          if (hasValidDiscount) ...[
            SizedBox(height: 4),
            Row(
              children: [
                // Savings Amount
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  // decoration: BoxDecoration(
                  //   color: Colors.green.withOpacity(0.2),
                  //   borderRadius: BorderRadius.circular(12),
                  //   border: Border.all(
                  //     color: Colors.green.withOpacity(0.3),
                  //     width: 1,
                  //   ),
                  // ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        // weight: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        size: 20,
                      ),
                      // Text(
                      //   '${savingsAmount.toStringAsFixed(0)}',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.green[800],
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      Text(
                        '${bestOffer!.discountPercentage}%',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),

                // Original Price (crossed out)
                Text(
                  "₹${widget.product.price.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.secondaryColor.withOpacity(0.7),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.secondaryColor.withOpacity(0.7),
                    decorationThickness: 2,
                  ),
                ),
                SizedBox(width: 4),
                // Current/Discounted Price
                Text(
                  hasValidDiscount
                      ? "₹${discountedPrice.toStringAsFixed(0)}"
                      : "₹${widget.product.price.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // // Discount Percentage
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            //   decoration: BoxDecoration(
            //     color: Colors.red.withOpacity(0.2),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(
            //       color: Colors.red.withOpacity(0.3),
            //       width: 1,
            //     ),
            //   ),
            //   child: Text(
            //     '${bestOffer!.discountPercentage}% OFF',
            //     style: TextStyle(
            //       fontSize: 12,
            //       color: Colors.red[800],
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ] else ...[
            // No Discount - Just show the original price
            Text(
              "₹${widget.product.price.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Expanded(
      child: Container(
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

        /// 👇 Offers List
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
                    if (offer.discountPercentage != 0) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                    ],

                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Text(
                    //     '${offer.discountPercentage}% OFF',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 👇 Shimmer on offer title
                          Shimmer.fromColors(
                            baseColor: Colors.green,
                            highlightColor: Colors.lightGreenAccent,
                            child: Text(
                              offer.offerTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if (offer.offerDescription.isNotEmpty)
                            Text(
                              offer.offerDescription,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 20,
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
    return Expanded(
      child: Container(
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

  // Widget _buildReviewsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Reviews",
  //         style: TextStyle(
  //           fontSize: 22,
  //           fontWeight: FontWeight.bold,
  //           color: AppColors.textColor,
  //         ),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.rate_review_outlined,
  //                 color: AppColors.primaryColor,
  //                 size: 20,
  //               ),
  //               SizedBox(width: 8),
  //               Text(
  //                 'Reviews (${widget.product.reviews.length})',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.textColor,
  //                 ),
  //               ),
  //             ],
  //           ),

  //           // if (widget.product.reviews.length > 1)
  //           //   TextButton(
  //           //     onPressed: _navigateToReviews,
  //           //     child: Text(
  //           //       'See All',
  //           //       style: TextStyle(
  //           //         color: AppColors.primaryColor,
  //           //         fontWeight: FontWeight.w600,
  //           //       ),
  //           //     ),
  //           //   ),
  //         ],
  //       ),
  //       SizedBox(height: 12),
  //       ...widget.product.reviews
  //           .take(5)
  //           .map(
  //             (review) => Container(
  //               margin: EdgeInsets.only(bottom: 12),
  //               padding: EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: AppColors.surfaceTint,
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(
  //                   color: AppColors.primaryColor.withOpacity(0.1),
  //                 ),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           review.customer,
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: AppColors.textColor,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                       ),
  //                       Row(
  //                         children: List.generate(5, (starIndex) {
  //                           return Icon(
  //                             starIndex < review.rating
  //                                 ? Icons.star_rounded
  //                                 : Icons.star_border_rounded,
  //                             color: Colors.amber,
  //                             size: 16,
  //                           );
  //                         }),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 8),
  //                   Text(
  //                     review.comment,
  //                     style: TextStyle(
  //                       color: AppColors.textSecondary,
  //                       fontSize: 13,
  //                       height: 1.4,
  //                     ),
  //                   ),
  //                   SizedBox(height: 4),
  //                   Text(
  //                     _formatDate(review.createdAt),
  //                     style: TextStyle(
  //                       color: AppColors.textSecondary,
  //                       fontSize: 11,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           )
  //           .toList(),
  //     ],
  //   );
  // }
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Reviews",
        //   style: TextStyle(
        //     fontSize: 22,
        //     fontWeight: FontWeight.bold,
        //     color: AppColors.textColor,
        //   ),
        // ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon(
                //   Icons.rate_review_outlined,
                //   color: AppColors.primaryColor,
                //   size: 20,
                // ),
                SizedBox(width: 8),
                Text(
                  'Reviews (${widget.product.reviews.length})',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            // Agar reviews > 3 to "See All" show karna
            if (widget.product.reviews.length > 3)
              TextButton(
                onPressed: _navigateToReviews,
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12),

        /// 👇 Horizontal Scrollable Reviews
        SizedBox(
          height: 140, // fixed height for horizontal list
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.product.reviews
                .take(5)
                .length, // max 5 reviews show
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final review = widget.product.reviews[index];
              return Container(
                width: 250, // card width
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < review.rating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        review.comment,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (widget.product.stock <= 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      padding: const EdgeInsets.all(16.0),
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
          Expanded(
            child: Container(
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
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: placeOrderController.isBuyProductLoading.value
                      ? null
                      : () {
                          AuthUtils.runIfLoggedInAndHasAddress(() {
                            placeOrderController.buyProduct(
                              productId: widget.product.id,
                              quantity: 1,
                            );
                          });
                        },
                  icon: placeOrderController.isBuyProductLoading.value
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
                    placeOrderController.isBuyProductLoading.value
                        ? "Processing..."
                        : "Buy Now",
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
