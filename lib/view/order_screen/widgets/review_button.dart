import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Xkart/view/reviews_screen/review_controller/review_controller.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/view/order_screen/widgets/add_review_popup.dart';

class ReviewButton extends StatelessWidget {
  final dynamic orderProduct;
  final dynamic order;
  final dynamic productInfo;

  final ReviewController _reviewController = Get.find();

  ReviewButton({
    super.key,
    required this.orderProduct,
    required this.order,
    required this.productInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: _reviewController.isSubmitting.value
            ? null
            : () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (_) => AddReviewPopup(
                    productName: orderProduct.product.name,
                    productImageUrl: orderProduct.product.images.first,
                    orderId: order.id,
                    onSubmit: (rating, comment) async {
                      try {
                        if (productInfo.reviews != null &&
                            productInfo.reviews.isNotEmpty) {
                          await _reviewController.updateReview(
                            productId: orderProduct.product.id,
                            rating: rating,
                            comment: comment,
                          );
                        } else {
                          await _reviewController.addReview(
                            orderId: order.id,
                            productId: orderProduct.product.id,
                            rating: rating,
                            comment: comment,
                          );
                        }
                      } catch (e) {
                        // Error will be handled in the popup
                        rethrow;
                      }
                    },
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: _reviewController.isSubmitting.value
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    "Write a Review",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
