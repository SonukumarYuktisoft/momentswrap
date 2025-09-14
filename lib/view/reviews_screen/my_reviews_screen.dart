import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/controllers/review_controller/review_controller.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/view/widgets/build_app_bar.dart';
import 'package:Xkart/models/review_model/review_model.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final ReviewController _reviewController = Get.put(ReviewController());
  String _selectedSort = 'newest';

  final List<Map<String, String>> _sortOptions = [
    {'value': 'newest', 'label': 'Newest First'},
    {'value': 'oldest', 'label': 'Oldest First'},
    {'value': 'highest_rating', 'label': 'Highest Rating'},
    {'value': 'lowest_rating', 'label': 'Lowest Rating'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMyReviews();
  }

  Future<void> _loadMyReviews() async {
    await _reviewController.getMyReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BuildAppBar(title: 'My Reviews', showBack: false),
      body: Obx(() {
        if (_reviewController.isLoading.value) {
          return _buildLoadingState();
        }

        if (_reviewController.hasError.value) {
          return _buildErrorState();
        }

        if (_reviewController.myReviews.isEmpty) {
          return _buildEmptyState();
        }

        return _buildReviewsList();
      }),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          SizedBox(height: 16),
          Text(
            'Loading your reviews...',
            style: TextStyle(color: AppColors.textOnSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _reviewController.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textOnSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMyReviews,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 80,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t written any reviews yet.\nStart shopping and share your experiences!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to products or home screen
                Get.offAllNamed('/home'); // Adjust route as needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Start Shopping',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    final sortedReviews = _reviewController.sortReviews(
      _reviewController.myReviews,
      _selectedSort,
    );

    return Column(
      children: [
        _buildHeader(sortedReviews.length),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadMyReviews,
            color: AppColors.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedReviews.length,
              itemBuilder: (context, index) {
                return _buildReviewCard(sortedReviews[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(int reviewCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.backgroundColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$reviewCount Review${reviewCount != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: _selectedSort,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedSort = newValue;
            });
          }
        },
        underline: const SizedBox(),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primaryColor,
        ),
        items: _sortOptions.map<DropdownMenuItem<String>>((option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(
              option['label']!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewHeader(review),
            const SizedBox(height: 12),
            _buildRatingStars(review.rating),
            const SizedBox(height: 12),
            _buildReviewComment(review.comment),
            const SizedBox(height: 16),
            _buildReviewActions(review),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewHeader(ReviewModel review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.product?.name ?? 'Product Name',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnBackground,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(review.createdAt),
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, review),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',

              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: AppColors.secondaryColor),
                  SizedBox(width: 8),
                  Text('Edit Review'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: AppColors.errorColor),
                  SizedBox(width: 8),
                  Text('Delete Review'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert, color: AppColors.textOnSecondary),
        ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : Colors.grey[300],
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewComment(String comment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        comment,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildReviewActions(ReviewModel review) {
    return Row(
      children: [
        // Expanded(
        //   child: OutlinedButton.icon(
        //     onPressed: () => _viewProduct(review),
        //     icon: const Icon(Icons.visibility, size: 16),
        //     label: const Text('View Product'),
        //     style: OutlinedButton.styleFrom(
        //       foregroundColor: AppColors.primaryColor,
        //       side: const BorderSide(color: AppColors.primaryColor),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //   ),
        // ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _editReview(review),
            icon: const Icon(Icons.edit, size: 16, color: Colors.black),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(String action, ReviewModel review) {
    switch (action) {
      case 'edit':
        _editReview(review);
        break;
      case 'delete':
        _confirmDeleteReview(review);
        break;
    }
  }

  void _editReview(ReviewModel review) {
    Get.dialog(
      _EditReviewDialog(review: review, onUpdate: () => _loadMyReviews()),
    );
  }

  void _confirmDeleteReview(ReviewModel review) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Review'),
        content: const Text(
          'Are you sure you want to delete this review? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await _reviewController.deleteReview(
                review.product?.id ?? '',
              );
              if (success) {
                await _loadMyReviews();
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewProduct(ReviewModel review) {
    if (review.product?.id != null) {
      Get.toNamed(
        '/product-details',
        arguments: {'productId': review.product!.id},
      );
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}

class _EditReviewDialog extends StatefulWidget {
  final ReviewModel review;
  final VoidCallback onUpdate;

  const _EditReviewDialog({required this.review, required this.onUpdate});

  @override
  State<_EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<_EditReviewDialog> {
  final ReviewController _reviewController = Get.find<ReviewController>();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _rating = widget.review.rating;
    _commentController.text = widget.review.comment;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.review.product?.name ?? 'Product',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Rating:'),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: index < _rating ? Colors.amber : Colors.grey,
                  size: 30,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text('Comment:'),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your review...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        Obx(
          () => ElevatedButton(
            onPressed: _reviewController.isSubmitting.value
                ? null
                : () async {
                    await _reviewController.updateReview(
                      productId: widget.review.product?.id ?? '',
                      rating: _rating,
                      comment: _commentController.text.trim(),
                    );
                    if (!_reviewController.hasError.value) {
                      Get.back();
                      widget.onUpdate();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: _reviewController.isSubmitting.value
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textOnPrimary,
                    ),
                  )
                : Text(
                    'Update',
                    style: TextStyle(color: AppColors.textOnPrimary),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
