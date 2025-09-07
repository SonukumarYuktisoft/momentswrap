import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/view/reviews_screen/reviews_screen.dart';
import 'package:momentswrap/view/search_screens/search_screen.dart';
import 'package:momentswrap/view/splash_screen/widgets/all_products_screen.dart';
import 'package:momentswrap/view/splash_screen/widgets/horizontal_productList.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/order_controller/order_controller.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Get.to(() => SearchAndFiltersBar());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar with Image Carousel
            _buildImageCarousel(displayImages, hasValidImages),

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

                      // Stock Status
                      _buildStockStatus(),
                      SizedBox(height: 20),

                      // Material & Warranty Info
                      _buildProductInfo(),
                      SizedBox(height: 20),

                    Column(
                        children: [

                           if (similarProducts.isNotEmpty) ...[
                      HorizontalProductList(
                        title: 'Similar Products',
                        products: similarProducts,
                        onSeeAll: () => _navigateToAllProducts('similar'),
                        onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                        },
                      ),
                      SizedBox(height: 20),
                    ],

                          // Featured Products
                          HorizontalProductList(
                            title: "Featured Products",
                            products: productController.getRecommendedProducts(limit: 10),
                            onSeeAll: () {
                              Get.to(() => AllProductsPage(
                                title: "Featured Products",
                                products: productController.getRecommendedProducts(limit: 50),
                                onProductTap: (product) {
                                  Get.to(() => ProductDetailScreen(product: product));
                                },
                              ));
                            },
                            onProductTap: (product) {
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          ),

                          SizedBox(height: 16),

                          // Special Offers
                          HorizontalProductList(
                            title: "Special Offers",
                            products: productController.getSpecialOfferProducts(limit: 10),
                            onSeeAll: () {
                              Get.to(() => AllProductsPage(
                                title: "Special Offers",
                                products: productController.getSpecialOfferProducts(limit: 50),
                                onProductTap: (product) {
                                  Get.to(() => ProductDetailScreen(product: product));
                                },
                                titleIcon: Icons.local_offer,
                              ));
                            },
                            onProductTap: (product) {
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          ),

                          SizedBox(height: 16),

                          // Trending Products
                          HorizontalProductList(
                            title: "Trending Now",
                            products: productController.getTrendingProducts(limit: 10),
                            onSeeAll: () {
                              Get.to(() => AllProductsPage(
                                title: "Trending Now",
                                products: productController.getTrendingProducts(limit: 50),
                                onProductTap: (product) {
                                  Get.to(() => ProductDetailScreen(product: product));
                                },
                                titleIcon: Icons.trending_up,
                              ));
                            },
                            onProductTap: (product) {
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          ),

                          SizedBox(height: 16),

                          // High Rating Products
                          HorizontalProductList(
                            title: "Top Rated",
                            products: productController.getHighRatingProducts(limit: 10),
                            onSeeAll: () {
                              Get.to(() => AllProductsPage(
                                title: "Top Rated Products",
                                products: productController.getHighRatingProducts(limit: 50),
                                onProductTap: (product) {
                                  Get.to(() => ProductDetailScreen(product: product));
                                },
                                titleIcon: Icons.star,
                              ));
                            },
                            onProductTap: (product) {
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          ),

                          SizedBox(height: 16),

                          // Recently Added
                          HorizontalProductList(
                            title: "Recently Added",
                            products: productController.getRecentProducts(limit: 10),
                            onSeeAll: () {
                              Get.to(() => AllProductsPage(
                                title: "Recently Added",
                                products: productController.getRecentProducts(limit: 50),
                                onProductTap: (product) {
                                  Get.to(() => ProductDetailScreen(product: product));
                                },
                                titleIcon: Icons.new_releases,
                              ));
                            },
                            onProductTap: (product) {
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 32),
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

  Widget _buildImageCarousel(List<String> displayImages, bool hasValidImages) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      floating: false,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      // leading: Container(
      //   margin: EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: AppColors.accentColor.withOpacity(0.9),
      //     borderRadius: BorderRadius.circular(12),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         blurRadius: 8,
      //         offset: Offset(0, 2),
      //       ),
      //     ],
      //   ),
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back_ios_new,
      //       color: AppColors.secondaryColor,
      //       size: 20,
      //     ),
      //     onPressed: () => Get.back(),
      //   ),
      // ),
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
                imageUrl: hasValidImages ? widget.product.images.first : "",
                shareUrl:
                    'https://moment-wrap-frontend.vercel.app/product/${widget.product.id}',
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
              // Main Image Carousel
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

              // Improved Small Image Thumbnails at Bottom (Reference Image Style)
              if (displayImages.length > 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Page Indicator Dots
                      Container(
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
                      SizedBox(height: 12),

                      // Enhanced Thumbnail Images (Like Reference Image)
                      Container(
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayImages.length,
                          itemBuilder: (context, index) {
                            final isSelected = currentImageIndex == index;
                            return GestureDetector(
                              onTap: () {
                                pageController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 12),
                                width: 65,
                                height: 70,
                                padding: EdgeInsets.all(
                                  4,
                                ), // Padding for white border effect
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // White background like reference
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.withOpacity(0.3),
                                    width: isSelected ? 2.5 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: hasValidImages
                                      ? Image.network(
                                          displayImages[index],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[100],
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: 24,
                                                    color: Colors.grey[400],
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: Colors.grey[100],
                                          child: Icon(
                                            Icons.image_outlined,
                                            size: 24,
                                            color: Colors.grey[400],
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
            ],
          ),
        ),
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
      case 'rating':
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
    Get.to(() => ReviewsPage(product: widget.product));
  }

  // Rest of the widget methods remain the same...
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
              // // Product ID Badge
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //   decoration: BoxDecoration(
              //     color: AppColors.primaryLight,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Text(
              //     'ID: ${widget.product.productId}',
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w600,
              //       color: AppColors.primaryColor,
              //     ),
              //   ),
              // ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
