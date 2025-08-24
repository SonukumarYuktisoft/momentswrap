import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/util/common/full_loader_screens.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String image, title, subtitle, price;
  final String? productId;
  final List<Offer>? offers;
  final void Function()? addToCart;
  final bool? isAddCartLoading;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    this.productId,
    this.offers,
    this.addToCart,
    this.isAddCartLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  image,
                  height: 120,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    '${productId}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 3),
                Row(
                  children: offers!
                      .map(
                        (e) => Text(
                          e.discountPercentage.toString(),
                          style: TextStyle(
                            decoration: TextDecoration.combine([
                              TextDecoration.lineThrough,
                            ]),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                   child: IconButton(
                    onPressed:addToCart,
                    icon: 
                         Icon(
                            Icons.shopping_bag_outlined,
                            size: 20,
                            color: AppColors.secondaryColor,
                          ),
                ),)

                // Obx(() => Container(
                //   padding: const EdgeInsets.all(0),
                //   decoration: BoxDecoration(
                //     color: cartController.isAddCartLoading.value
                //         ? AppColors.primaryColor.withOpacity(0.6)  // Disabled appearance
                //         : AppColors.primaryColor,
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                //   child: IconButton(
                //     onPressed: cartController.isAddCartLoading.value
                //         ? null
                //         : addToCart,
                //     icon: cartController.isAddCartLoading.value
                //         ? SizedBox(
                //             width: 20,
                //             height: 20,
                //             child: CircularProgressIndicator(
                //               strokeWidth: 2,
                //               color: AppColors.secondaryColor,
                //             ),
                //           )
                //         : Icon(
                //             Icons.shopping_bag_outlined,
                //             size: 20,
                //             color: AppColors.secondaryColor,
                //           ),
                //   ),
                // )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
