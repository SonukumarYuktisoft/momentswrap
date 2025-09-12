import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack; // 🔑 new flag (default false)
  final Widget? leadingIcon;

  const BuildAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return AppBar(
      leadingWidth: 50,
      centerTitle: true,
      automaticallyImplyLeading: false, // Flutter default back ko disable kiya
      leading: showBack
          ? (leadingIcon ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Get.back(),
              ))
          : null,
      toolbarHeight: 70,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
      backgroundColor: AppColors.accentColor,
      foregroundColor: AppColors.textColor,
      elevation: 0,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
