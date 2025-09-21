import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/controllers/cart_controller/cart_controller.dart';
import 'package:Xkart/controllers/location_controller/location_controller.dart';
import 'package:Xkart/controllers/product_controller/product_controller.dart';
import 'package:Xkart/controllers/profile_controller/profile_controller.dart';
import 'package:Xkart/models/product_models/product_model.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/util/common/auth_utils.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/util/constants/app_images_string.dart';
import 'package:Xkart/util/constants/simmers/horizontal_productList_shimmer.dart';
import 'package:Xkart/view/ai_assistant/ai_assistant_screen.dart'
    hide AppRoutes;
import 'package:Xkart/view/home_screen/product_card.dart';
import 'package:Xkart/view/home_screen/product_detail_screen/product_detail_screen.dart';
import 'package:Xkart/view/widgets/all_products_screen.dart';
import 'package:Xkart/view/events_screen/events_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Initialize with default tab count, will be updated when categories load
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToProducts() {
    // Scroll to the products section when a category is selected
    if (_productsKey.currentContext != null) {
      Scrollable.ensureVisible(
        _productsKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final LocationController locationController = Get.put(LocationController());
    final CartController cartController = Get.put(CartController());
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // Update TabController when categories change
        if (controller.categories.length != _tabController.length) {
          _tabController.dispose();
          _tabController = TabController(
            length: controller.categories.length,
            vsync: this,
          );

          // Listen to tab changes and trigger category selection + scroll
          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              final selectedCategory =
                  controller.categories[_tabController.index];
              controller.selectCategory(selectedCategory);
              // Delay scroll to allow content to load
              Future.delayed(
                const Duration(milliseconds: 100),
                _scrollToProducts,
              );
            }
          });
        }

        return Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      // App Bar
                      SliverAppBar(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColor,
                        title: Text(
                          'Moments Wrap',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        centerTitle: true,
                        iconTheme: IconThemeData(
                          color: AppColors.secondaryColor,
                        ),
                        actions: [
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                _buildIconButton(
                                  icon: Icons.notifications_outlined,
                                  onTap: () => Get.toNamed(
                                    AppRoutes.notificationsScreen,
                                  ),
                                ),
                                SizedBox(width: 8),
                                _buildIconButton(
                                  icon: Icons.location_on_outlined,
                                  onTap: () async =>
                                      await locationController.getAddress(),
                                ),
                              ],
                            ),
                          ),
                        ],
                        pinned: true,
                      ),

                      // Floating Search Bar
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: 70,
                        flexibleSpace: _buildFloatingSearchBar(),
                        automaticallyImplyLeading: false,
                      ),

                      // TabBar for Categories
                      if (controller.categories.isNotEmpty)
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverHeaderDelegate(
                            minHeight: 60,
                            maxHeight: 60,
                            child: Material(
                              color: AppColors.backgroundColor,
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicatorColor: AppColors.primaryColor,
                                  indicatorWeight: 3,
                                  labelColor: AppColors.primaryColor,
                                  unselectedLabelColor: AppColors.textColor
                                      .withOpacity(0.6),
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  tabs: controller.categories
                                      .map((category) => Tab(text: category))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ];
                  },
              body: RefreshIndicator(
                onRefresh: () async {
                  await controller.initializeData();
                  await controller.filterProducts();
                },
                color: AppColors.primaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(profileController),

                      // Upcoming Events
                      const ModernUpcomingEventsCard(),
                      SizedBox(height: 16),

                      // Special Offers Carousel
                      _buildOffersCarousel(),
                      SizedBox(height: 24),

                      // Products Section - This is where we scroll to
                      Container(
                        key: _productsKey,
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return _buildLoadingShimmers();
                          }

                          if (!controller.hasProducts) {
                            return _buildNoProducts();
                          }

                          return _buildProductSections(controller);
                        }),
                      ),

                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            // Cart Loading Overlay
            Obx(() {
              if (cartController.isAddCartLoading.value) {
                return _buildCartLoadingOverlay();
              }
              return SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }
}

// Generic Sliver Header Delegate
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// AI Assistant Bottom Sheet Method
void _showAIAssistantBottomSheet() {
  Get.bottomSheet(
    AIAssistantBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: Duration(milliseconds: 300),
    exitBottomSheetDuration: Duration(milliseconds: 200),
  );
}

/// Floating Search Bar with modern design
Widget _buildFloatingSearchBar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.searchScreen),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600], size: 22),
            SizedBox(width: 12),
            Text(
              "Search for products...",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Icon(Icons.camera_alt_outlined, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    ),
  );
}

/// Loading Shimmers
Widget _buildLoadingShimmers() {
  return Column(
    children: [
      HorizontalProductListShimmer(),
      SizedBox(height: 16),
      HorizontalProductListShimmer(),
      SizedBox(height: 16),
      HorizontalProductListShimmer(),
      SizedBox(height: 16),
      HorizontalProductListShimmer(),
    ],
  );
}

/// Products Sections
Widget _buildProductSections(ProductController controller) {
  return Column(
    children: [
      HorizontalProductList(
        title: "Featured Products",
        products: controller.getRecommendedProducts(limit: 10),
        onSeeAll: () {
          Get.to(
            () => AllProductsPage(
              title: "Featured Products",
              products: controller.getRecommendedProducts(limit: 50),
              onProductTap: (product) =>
                  Get.to(() => ProductDetailScreen(product: product)),
            ),
          );
        },
        onProductTap: (product) =>
            Get.to(() => ProductDetailScreen(product: product)),
      ),
      SizedBox(height: 16),
      HorizontalProductList(
        title: "Special Offers",
        products: controller.getSpecialOfferProducts(limit: 10),
        onSeeAll: () {
          Get.to(
            () => AllProductsPage(
              title: "Special Offers",
              products: controller.getSpecialOfferProducts(limit: 50),
              onProductTap: (product) =>
                  Get.to(() => ProductDetailScreen(product: product)),
            ),
          );
        },
        onProductTap: (product) =>
            Get.to(() => ProductDetailScreen(product: product)),
      ),
      SizedBox(height: 16),
      HorizontalProductList(
        title: "Trending Now",
        products: controller.getTrendingProducts(limit: 10),
        onSeeAll: () {
          Get.to(
            () => AllProductsPage(
              title: "Trending Now",
              products: controller.getTrendingProducts(limit: 50),
              onProductTap: (product) =>
                  Get.to(() => ProductDetailScreen(product: product)),
            ),
          );
        },
        onProductTap: (product) =>
            Get.to(() => ProductDetailScreen(product: product)),
      ),
      SizedBox(height: 16),
      HorizontalProductList(
        title: "Top Rated",
        products: controller.getHighRatingProducts(limit: 10),
        onSeeAll: () {
          Get.to(
            () => AllProductsPage(
              title: "Top Rated",
              products: controller.getHighRatingProducts(limit: 50),
              onProductTap: (product) =>
                  Get.to(() => ProductDetailScreen(product: product)),
            ),
          );
        },
        onProductTap: (product) =>
            Get.to(() => ProductDetailScreen(product: product)),
      ),
      SizedBox(height: 16),
      HorizontalProductList(
        title: "Recently Added",
        products: controller.getRecentProducts(limit: 10),
        onSeeAll: () {
          Get.to(
            () => AllProductsPage(
              title: "Recently Added",
              products: controller.getRecentProducts(limit: 50),
              onProductTap: (product) =>
                  Get.to(() => ProductDetailScreen(product: product)),
            ),
          );
        },
        onProductTap: (product) =>
            Get.to(() => ProductDetailScreen(product: product)),
      ),
    ],
  );
}

/// Welcome Section
Widget _buildWelcomeSection(ProfileController profileController) {
  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.accentColor,
          AppColors.accentColor.withOpacity(0.95),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.2),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(Icons.waving_hand, color: AppColors.primaryColor),
        SizedBox(width: 12),
        Obx(
          () => Text(
            "Hello, ${profileController.firstName ?? 'User'}",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.secondaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.secondaryColor),
    ),
  );
}

/// Offers Carousel
Widget _buildOffersCarousel() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Special Offers",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 12),
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
          items: [
            ModernBannerCard(
              imageUrl: AppImagesString.offerBanner1,
              title: "Special Offers",
              subtitle: "Up to 50% off",
            ),
            ModernBannerCard(
              imageUrl: AppImagesString.offerBanner2,
              title: "Gift Wrapping",
              subtitle: "Premium collection",
            ),
            ModernBannerCard(
              imageUrl: AppImagesString.offerBanner3,
              title: "Birthday Specials",
              subtitle: "Make it memorable",
            ),
            ModernBannerCard(
              imageUrl: AppImagesString.offerBanner4,
              title: "Anniversary Gifts",
              subtitle: "Celebrate love",
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildNoProducts() {
  return Container(
    height: 200,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            "No products available",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCartLoadingOverlay() {
  return Positioned.fill(
    child: Container(
      color: AppColors.secondaryColor.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryColor),
            SizedBox(height: 16),
            Text(
              "Adding to cart...",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Horizontal Product List Widget
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

    final displayProducts = products.length > 10
        ? products.sublist(0, 10)
        : products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + See All Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          height: 220,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: displayProducts.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              final CartController cartController = Get.put(CartController());

              return GestureDetector(
                onTap: () => onProductTap(product),
                child: SizedBox(
                  width: 160,
                  child: ModernProductCard(
                    image: product.images.isNotEmpty
                        ? product.images.first
                        : '',
                    title: product.name,
                    subtitle: product.shortDescription,
                    price: "₹${product.price}",
                    offers: product.offers,
                    stock: product.stock,
                    showAddToCart: false,
                    addToCart: () {
                      AuthUtils.runIfLoggedIn(() async {
                        await cartController.addToCart(
                          productId: product.id,
                          quantity: 1,
                          image: product.images.isNotEmpty
                              ? product.images.first
                              : '',
                          totalPrice: product.price.toDouble(),
                        );
                      });
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

class ModernUpcomingEventsCard extends StatelessWidget {
  const ModernUpcomingEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentColor,
            AppColors.accentColor.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Title Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Upcoming Events",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Modern Event Items
          _ModernEventRow(
            icon: Icons.cake_outlined,
            title: "Tara's Birthday",
            subtitle: "29 Years",
            date: "1 November",
          ),
          const SizedBox(height: 12),

          _ModernEventRow(
            icon: Icons.cake_outlined,
            title: "Laila's Birthday",
            subtitle: "22 Years",
            date: "1 November",
          ),

          const SizedBox(height: 16),

          // Modern See More Button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Get.to(EventsScreens());
                },
                icon: Text(
                  'See More',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                label: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernEventRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;

  const _ModernEventRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textColor.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModernBannerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const ModernBannerCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 180,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.primaryColor,
                    ),
                  );
                },
              ),
            ),
            // Gradient Overlay
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.secondaryColor.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Text Overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.accentColor.withOpacity(0.8),
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
}
