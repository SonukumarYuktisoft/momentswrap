import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/controllers/location_controller/location_controller.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/coustom_curve.dart';
import 'package:momentswrap/util/common/full_loader_screens.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:momentswrap/view/add_to_cart_screen/cart_Item_card.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          RefreshIndicator(
            onRefresh: () async {
              controller.clearFilters();
              await locationController.getAddress();
            },
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // Top image section
                    ClipPath(
                      clipper: CustomCurve(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 234, 184, 184),
                        ),
                        child: Column(
                          children: [
                            SearchAndFiltersBar(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    locationController.getAddress();
                                  },
                                  icon: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Obx(() {
                                  return Text(locationController.address.value);
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSizes.spaceBtwItems),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          scrollPhysics: BouncingScrollPhysics(),
                          viewportFraction: 1.0,
                        ),
                        items: [
                          RoundedImage(
                            imageUrl: AppImagesString.offerBanner1,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          RoundedImage(
                            imageUrl: AppImagesString.offerBanner2,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          RoundedImage(
                            imageUrl: AppImagesString.offerBanner3,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          RoundedImage(
                            imageUrl: AppImagesString.offerBanner4,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),

                    CartItemCard(
                      imageUrl: AppImagesString.productImage1,
                      title: 'apple',
                      price: 200.0,
                      quantity: 2,
                      onIncrease: () {},
                      onDecrease: () {},
                      onDelete: () {},
                    ),
                    SizedBox(height: 16),

                    Obx(() {
                      final productResponse = controller.products.value;

                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (productResponse == null ||
                          productResponse.data.isEmpty) {
                        return Center(child: Text("No products available"));
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: productResponse.data.length,
                        itemBuilder: (context, index) {
                          final item = productResponse.data[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductDetailScreen(product: item));
                            },
                            child: ProductCard(
                              image: item.images.isNotEmpty
                                  ? item.images.first
                                  : '',
                              title: item.name,
                              subtitle: item.shortDescription,
                              price: "₹${item.price}",
                              offers: item.offers,
                              addToCart: () async {
                                await cartController.addToCart(
                                  productId: item.id,
                                  quantity: 1,
                                  image: item.images.isNotEmpty
                                      ? item.images.first
                                      : '',
                                  totalPrice: item.price.toDouble(),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }),
                    SizedBox(height: AppSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
          ),

          // Single Global Full Screen Loader
          Obx(() {
            if (cartController.isAddCartLoading.value) {
              return Positioned.fill(
                child: FullLoaderScreens(
                  animationPath: 'assets/animations/addtocart.json',
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

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
          ),
        ),
      ),
    );
  }
}
