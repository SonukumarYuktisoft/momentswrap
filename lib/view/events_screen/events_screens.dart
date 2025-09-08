import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart'
    show CartController;
import 'package:momentswrap/controllers/location_controller/location_controller.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
import 'package:momentswrap/controllers/search_controller/search_product_controller.dart';
import 'package:momentswrap/controllers/profile_controller/profile_controller.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/view/home_screen/home_screen.dart';
import 'package:momentswrap/view/home_screen/product_card.dart';
import 'package:momentswrap/view/home_screen/product_detail_screen.dart';
import 'package:momentswrap/view/search_screens/search_screen.dart';
import 'package:momentswrap/view/widgets/all_products_screen.dart';

class EventsScreens extends StatelessWidget {
  const EventsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final LocationController locationController = Get.put(LocationController());
    final CartController cartController = Get.put(CartController());
    final ProfileController profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text('Events', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Get.toNamed(AppRoutes.searchScreen);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
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

              // return Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: GridView.builder(
              //     shrinkWrap: true,
              //     // physics: NeverScrollableScrollPhysics(),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       childAspectRatio: 0.68,
              //       crossAxisSpacing: 12,
              //       mainAxisSpacing: 12,
              //     ),
              //     itemCount: productResponse.data.length,
              //     itemBuilder: (context, index) {
              //       final item = productResponse.data[index];
              //       return GestureDetector(
              //         onTap: () {
              //           Get.to(ProductDetailScreen(product: item));
              //         },
              //         child: ModernProductCard(
              //           image: item.images.isNotEmpty ? item.images.first : '',
              //           title: item.name,
              //           subtitle: item.shortDescription,
              //           price: "₹${item.price}",
              //           offers: item.offers,
              //           stock: item.stock,
              //           addToCart: () {
              //             AuthUtils.runIfLoggedIn(() async {
              //               await cartController.addToCart(
              //                 productId: item.id,
              //                 quantity: 1,
              //                 image: item.images.isNotEmpty
              //                     ? item.images.first
              //                     : '',
              //                 totalPrice: item.price.toDouble(),
              //               );
              //             });
              //           },
              //         ),
              //       );
              //     },
              //   ),
              // );

              return Column(
                children: [
                  // Featured Products
                  HorizontalProductList(
                    title: "Featured Products",
                    products: controller.getRecommendedProducts(limit: 10),
                    onSeeAll: () {
                      Get.to(
                        () => AllProductsPage(
                          title: "Featured Products",
                          products: controller.getRecommendedProducts(
                            limit: 50,
                          ),
                          onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                        ),
                      );
                    },
                    onProductTap: (product) {
                      Get.to(() => ProductDetailScreen(product: product));
                    },
                  ),

                  SizedBox(height: 16),

                  // Special Offers
                  HorizontalProductList(
                    title: "Special Offers",
                    products: controller.getSpecialOfferProducts(limit: 10),
                    onSeeAll: () {
                      Get.to(
                        () => AllProductsPage(
                          title: "Special Offers",
                          products: controller.getSpecialOfferProducts(
                            limit: 50,
                          ),
                          onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          titleIcon: Icons.local_offer,
                        ),
                      );
                    },
                    onProductTap: (product) {
                      Get.to(() => ProductDetailScreen(product: product));
                    },
                  ),

                  SizedBox(height: 16),

                  // Trending Products
                  HorizontalProductList(
                    title: "Trending Now",
                    products: controller.getTrendingProducts(limit: 10),
                    onSeeAll: () {
                      Get.to(
                        () => AllProductsPage(
                          title: "Trending Now",
                          products: controller.getTrendingProducts(limit: 50),
                          onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          titleIcon: Icons.trending_up,
                        ),
                      );
                    },
                    onProductTap: (product) {
                      Get.to(() => ProductDetailScreen(product: product));
                    },
                  ),

                  SizedBox(height: 16),

                  // High Rating Products
                  HorizontalProductList(
                    title: "Top Rated",
                    products: controller.getHighRatingProducts(limit: 10),
                    onSeeAll: () {
                      Get.to(
                        () => AllProductsPage(
                          title: "Top Rated Products",
                          products: controller.getHighRatingProducts(limit: 50),
                          onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          titleIcon: Icons.star,
                        ),
                      );
                    },
                    onProductTap: (product) {
                      Get.to(() => ProductDetailScreen(product: product));
                    },
                  ),

                  SizedBox(height: 16),

                  // Recently Added
                  HorizontalProductList(
                    title: "Recently Added",
                    products: controller.getRecentProducts(limit: 10),
                    onSeeAll: () {
                      Get.to(
                        () => AllProductsPage(
                          title: "Recently Added",
                          products: controller.getRecentProducts(limit: 50),
                          onProductTap: (product) {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          titleIcon: Icons.new_releases,
                        ),
                      );
                    },
                    onProductTap: (product) {
                      Get.to(() => ProductDetailScreen(product: product));
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
