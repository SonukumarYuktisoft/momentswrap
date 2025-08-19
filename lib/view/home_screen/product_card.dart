import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String image, title, subtitle, price;
  // final dynamic offer;
  final String productId;
  final void Function()? addToCart;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.productId,
    this.addToCart
    // required this.offer,
  });

  @override
  Widget build(BuildContext context) {
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
                    productId,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed:addToCart,
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 14,
                //   backgroundColor: AppColors.primaryColor,
                //   child: Icon(
                //     Icons.shopping_bag_outlined,
                //     size: 14,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
// import 'package:momentswrap/util/constants/app_colors.dart';
// import 'package:momentswrap/view/home_screen/product_detail_screen.dart';

// class ProductCard extends StatelessWidget {
//   final String image, title, subtitle, price;
//   final String productId; // Used internally but not displayed
//   final CartController cartController = Get.put(CartController());

//   ProductCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.price,
//     required this.productId, // Required but not shown in UI
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Image.network(
//                   image,
//                   height: 120,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Obx(() {
//                   final isInCart = cartController.cartItems
//                       .any((item) => item.product == productId);
//                   return CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 16,
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       icon: Icon(
//                         isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
//                         size: 16,
//                         color: isInCart ? Colors.green : AppColors.primaryColor,
//                       ),
//                       onPressed: () {
//                         if (isInCart) {
//                           cartController.removeFromCart(productId);
//                         } else {
//                           cartController.addToCart(
//                             productId: productId,
//                             quantity: 1,
//                             image: image,
//                             price: double.parse(price.replaceAll('₹', '')),
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               title,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               subtitle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   price,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Get.to(() => ProductDetailScreen(product: {
//                       'sId': productId,
//                       'image': image,
//                       'name': title,
//                       'shortDescription': subtitle,
//                       'price': double.parse(price.replaceAll('₹', '')),
//                       'longDescription': subtitle,
//                       'category': '',
//                     }));
//                   },
//                   child: Text(
//                     'View Details',
//                     style: TextStyle(color: AppColors.primaryColor),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
// import 'package:momentswrap/controllers/favorite_controller/favorite_controller.dart';
// import 'package:momentswrap/models/product_models/product_model.dart';
// import 'package:momentswrap/util/constants/app_colors.dart';
// import 'package:momentswrap/view/home_screen/product_detail_screen.dart';

// class ProductCard extends StatelessWidget {
//   final String image, title, subtitle, price;
//   final String productId;
//   final CartController cartController = Get.put(CartController());
//   final FavoriteController favoriteController = Get.put(FavoriteController());

//   ProductCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.price,
//     required this.productId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(
//           () => ProductDetailScreen(
//             product: {
//               'sId': productId,
//               'image': image,
//               'name': title,
//               'shortDescription': subtitle,
//               'price': double.parse(price.replaceAll('₹', '')),
//               'longDescription': subtitle,
//               'category': '',
//             },
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 5,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                   child: Image.network(
//                     image,
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Obx(() {
//                     final isInCart = cartController.cartItems.any(
//                       (item) => item.product == productId,
//                     );
//                     return CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 16,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: Icon(
//                           isInCart
//                               ? Icons.shopping_cart
//                               : Icons.shopping_cart_outlined,
//                           size: 16,
//                           color: isInCart
//                               ? Colors.green
//                               : AppColors.primaryColor,
//                         ),
//                         onPressed: () {
//                           if (isInCart) {
//                             cartController.removeFromCart(productId);
//                           } else {
//                             cartController.addToCart(
//                               productId: productId,
//                               quantity: 1,
//                               image: image,
//                               price: double.parse(price.replaceAll('₹', '')),
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Obx(() {
//                     final isFavorite = favoriteController.isFavorite(productId);
//                     return CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 16,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           size: 16,
//                           color: isFavorite
//                               ? Colors.red
//                               : AppColors.primaryColor,
//                         ),
//                         onPressed: () {
//                           favoriteController.toggleFavorite(
//                             Products(
//                               sId: productId,
//                               name: title,
//                               shortDescription: subtitle,
//                               price:
//                                   int.tryParse(price.replaceAll('₹', '')) ?? 0,
//                               image: image,
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 subtitle,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ),
//             // Spacer(),
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     price,
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Get.to(
//                         () => ProductDetailScreen(
//                           product: {
//                             'sId': productId,
//                             'image': image,
//                             'name': title,
//                             'shortDescription': subtitle,
//                             'price': double.parse(price.replaceAll('₹', '')),
//                             'longDescription': subtitle,
//                             'category': '',
//                           },
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'View Details',
//                       style: TextStyle(color: AppColors.primaryColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
