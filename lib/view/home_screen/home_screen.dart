import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/location_controller/location_controller.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
import 'package:momentswrap/controllers/profile_controller/profile_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/view/events_screen/events_screens.dart';
import 'package:momentswrap/view/home_screen/product_card.dart';
import 'package:momentswrap/view/home_screen/product_detail_screen.dart';
import 'package:momentswrap/view/home_screen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final LocationController locationController = Get.put(LocationController());
    final CartController cartController = Get.put(CartController());
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      drawer: _buildModernDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leadingWidth: 100,
        title: Text(
          'Moments Wrap',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      await locationController.getAddress();
                    },
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Main Content
          RefreshIndicator(
            onRefresh: () async {
              controller.clearFilters();
              // await locationController.getAddress();
              await controller.fetchAllProducts();
            },
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top gradient section with search
                    Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location row with modern styling
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentColor.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.secondaryColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Obx(() {
                                    return Text(
                                      locationController.address.value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                                ),
                                IconButton(
                                  onPressed: () {
                                    locationController.getAddress();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: AppColors.secondaryColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SearchAndFiltersBar(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Welcome section with modern card
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(20),
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
                            color: AppColors.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.waving_hand,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Hello, ${profileController.firstName}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "What would you like to wrap today?",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Modern Events Card
                    ModernUpcomingEventsCard(),

                    SizedBox(height: 16),

                    // Modern Carousel with gradient overlay
                    Padding(
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
                              scrollPhysics: BouncingScrollPhysics(),
                              viewportFraction: 0.9,
                              autoPlayInterval: Duration(seconds: 4),
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
                    ),

                    SizedBox(height: 24),

                    // Products Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Featured Products",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
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

                    SizedBox(height: 8),

                    // Modern Products Grid
                    Obx(() {
                      final productResponse = controller.products.value;

                      if (controller.isLoading.value) {
                        return Container(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      } else if (productResponse == null ||
                          productResponse.data.isEmpty) {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "No products available",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.68,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            final item = productResponse.data[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(ProductDetailScreen(product: item));
                              },
                              child: ModernProductCard(
                                image: item.images.isNotEmpty
                                    ? item.images.first
                                    : '',
                                title: item.name,
                                subtitle: item.shortDescription,
                                price: "₹${item.price}",
                                offers: item.offers,
                                stock: item.stock,
                                addToCart: (){
                                  AuthUtils.runIfLoggedIn(()async{
                                  await cartController.addToCart(
                                    productId: item.id,
                                    quantity: 1,
                                    image: item.images.isNotEmpty
                                        ? item.images.first
                                        : '',
                                    totalPrice: item.price.toDouble(),
                                  );
                                  });

                                },
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 100), // Extra bottom padding
                  ],
                ),
              ),
            ),
          ),

          // Modern Loading Overlay
          Obx(() {
            if (cartController.isAddCartLoading.value) {
              return Positioned.fill(
                child: Container(
                  color: AppColors.secondaryColor.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 3,
                          ),
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
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildModernDrawer() {
    return Drawer(
      backgroundColor: AppColors.accentColor,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Text(
                "Moments Wrap",
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Add drawer items here
        ],
      ),
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
              child: Image.asset(
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

// class ModernProductCard extends StatelessWidget {
//   final String image, title, subtitle, price;
//   final String? productId;
//   final List<Offer>? offers;
//   final void Function()? addToCart;
//   final int stock;

//   const ModernProductCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.price,
//     this.productId,
//     this.offers,
//     this.addToCart,
//     required this.stock,
//   });

//   @override
//   Widget build(BuildContext context) {
//     CartController cartController = Get.put(CartController());

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColors.accentColor,
//             AppColors.accentColor.withOpacity(0.98),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryColor.withOpacity(0.15),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image with modern styling
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   color: AppColors.backgroundColor,
//                   child: Image.network(
//                     image,
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: AppColors.backgroundColor,
//                         child: Icon(
//                           Icons.image_outlined,
//                           size: 48,
//                           color: Colors.grey[400],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // Product ID Badge
//               if (productId != null)
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       '#${productId}',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.accentColor,
//                       ),
//                     ),
//                   ),
//                 ),

//               // Favorite button
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.accentColor.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.favorite_border,
//                       size: 18,
//                       color: AppColors.primaryColor,
//                     ),
//                     padding: EdgeInsets.all(4),
//                     constraints: BoxConstraints(minWidth: 32, minHeight: 32),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Content section
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     title,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textColor,
//                     ),
//                   ),
//                   SizedBox(height: 4),

//                   // Subtitle
//                   Text(
//                     subtitle,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: AppColors.textColor.withOpacity(0.6),
//                     ),
//                   ),

//                   Spacer(),

//                   // Price and Add to Cart Row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               price,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//                             if (offers != null && offers!.isNotEmpty)
//                               Text(
//                                 "${offers!.first.discountPercentage}% off",
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.green[600],
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),

//                       // Modern Add to Cart Button
//                       if (stock > 0) ...[
//                         Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 AppColors.primaryColor,
//                                 AppColors.primaryColor.withOpacity(0.8),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.primaryColor.withOpacity(0.3),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: IconButton(
//                             onPressed: addToCart,
//                             icon: Icon(
//                               Icons.add_shopping_cart_outlined,
//                               size: 20,
//                               color: AppColors.accentColor,
//                             ),
//                             padding: EdgeInsets.all(8),
//                             constraints: BoxConstraints(
//                               minWidth: 36,
//                               minHeight: 36,
//                             ),
//                           ),
//                         ),
//                       ] else ...[
//                         Text(
//                           'Out of Stock',
//                           softWrap: true,
//                           style: TextStyle(
//                             overflow: TextOverflow.ellipsis,
//                             color: AppColors.errorColor,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class RoundedImage extends StatelessWidget {
  final double radius;
  final double? width;
  final double? height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit fit;
  final bool isNetworkImage;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;

  const RoundedImage({
    super.key,
    this.radius = AppSizes.borderRadiusMd,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = AppColors.backgroundColor,
    this.fit = BoxFit.contain,
    this.isNetworkImage = false,
    this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroundColor,
          border: border,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(radius)
              : BorderRadius.zero,
          child: Image(
            image: isNetworkImage
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.backgroundColor,
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
