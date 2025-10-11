import 'package:flutter/material.dart';
import 'package:Xkart/view/reviews_screen/review_model/review_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showProduct;

  const ReviewCardWidget({
    super.key,
    required this.review,
    this.onEdit,
    this.onDelete,
    this.showProduct = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Header
          Row(
            children: [
              // User Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    review.customerInitial,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.customerName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        if (review.isRecent) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      review.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating Stars
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < review.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                    SizedBox(width: 4),
                    Text(
                      '${review.rating}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Product Info (if showing product)
          if (showProduct && review.product != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: review.product!.primaryImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              review.product!.primaryImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.product!.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (review.product!.price != null)
                          Text(
                            review.product!.formattedPrice,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 12),

          // Review Comment
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              // Helpful Button (placeholder for future functionality)
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement helpful functionality
                },
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  'Helpful',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              Spacer(),

              // Edit and Delete buttons (if available)
              if (onEdit != null) ...[
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],

              if (onDelete != null) ...[
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  label: Text(
                    'Delete',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
