import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/controllers/review_controller/review_controller.dart';
import 'package:Xkart/models/review_model/review_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/view/reviews_screen/widgets/review_card_widget.dart';
import 'package:Xkart/view/reviews_screen/widgets/review_stats_widget.dart';
import 'package:Xkart/view/reviews_screen/widgets/write_review_widget.dart';

class ReviewsScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;

  const ReviewsScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with TickerProviderStateMixin {
  late ReviewController reviewController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _sortBy = 'newest';

  final List<Map<String, String>> _sortOptions = [
    {'label': 'Newest', 'value': 'newest'},
    {'label': 'Oldest', 'value': 'oldest'},
    {'label': 'Highest Rating', 'value': 'highest_rating'},
    {'label': 'Lowest Rating', 'value': 'lowest_rating'},
  ];

  @override
  void initState() {
    super.initState();
    reviewController = Get.put(ReviewController());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadReviews();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    await reviewController.getProductReviews(widget.productId);
    await reviewController.getMyReviews();
  }

  Future<void> _refreshReviews() async {
    await _loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (reviewController.isLoading.value) {
          return _buildLoadingState();
        }

        if (reviewController.hasError.value) {
          return _buildErrorState();
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _refreshReviews,
            color: AppColors.primaryColor,
            child: CustomScrollView(
              slivers: [
                // Reviews Statistics
                SliverToBoxAdapter(
                  child: ReviewStatsWidget(
                    reviews: reviewController.productReviews,
                    productName: widget.productName,
                  ),
                ),

                // Sort Section
                SliverToBoxAdapter(child: _buildSortSection()),

                // Reviews List or Empty State
                reviewController.productReviews.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState())
                    : _buildReviewsList(),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: _buildWriteReviewFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.accentColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.productName,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.accentColor.withOpacity(0.8),
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: AppColors.accentColor),
          onSelected: (value) {
            switch (value) {
              case 'my_reviews':
                _showMyReviews();
                break;
              case 'refresh':
                _refreshReviews();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'my_reviews',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 8),
                  Text('My Reviews'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading reviews...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Failed to Load Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              reviewController.errorMessage.value.isNotEmpty
                  ? reviewController.errorMessage.value
                  : 'Please check your connection and try again.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshReviews,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.accentColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sortOptions.map((option) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: _buildSortChip(option['label']!, option['value']!),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.accentColor : AppColors.textColor,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected && _sortBy != value) {
          setState(() {
            _sortBy = value;
          });
        }
      },
      backgroundColor: AppColors.surfaceTint,
      selectedColor: AppColors.primaryColor,
      checkmarkColor: AppColors.accentColor,
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.primaryColor.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight.withOpacity(0.3),
                  AppColors.primaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Reviews Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Be the first to share your experience with this product! Your review helps other customers make informed decisions.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showWriteReviewDialog(),
            icon: Icon(Icons.rate_review_outlined, size: 20),
            label: Text('Write First Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.accentColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
              shadowColor: AppColors.primaryColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    final sortedReviews = reviewController.sortReviews(
      reviewController.productReviews,
      _sortBy,
    );

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final review = sortedReviews[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: ReviewCardWidget(
              review: review,
              onEdit: _canEditReview(review) ? () => _editReview(review) : null,
              onDelete: _canDeleteReview(review)
                  ? () => _deleteReview(review)
                  : null,
            ),
          );
        }, childCount: sortedReviews.length),
      ),
    );
  }

  Widget _buildWriteReviewFAB() {
    final hasReviewed = reviewController.hasUserReviewedProduct(
      widget.productId,
    );

    return Obx(() {
      if (reviewController.isLoading.value) {
        return SizedBox.shrink();
      }

      return FloatingActionButton.extended(
        onPressed: hasReviewed ? null : () => _showWriteReviewDialog(),
        backgroundColor: hasReviewed
            ? Colors.grey[400]
            : AppColors.primaryColor,
        foregroundColor: AppColors.accentColor,
        icon: Icon(
          hasReviewed ? Icons.check_circle : Icons.rate_review_outlined,
          size: 20,
        ),
        label: Text(
          hasReviewed ? 'Already Reviewed' : 'Write Review',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: hasReviewed ? 2 : 6,
        heroTag: "write_review_fab",
      );
    });
  }

  void _showWriteReviewDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewWidget(
        productId: widget.productId,
        productName: widget.productName,
        productImage: widget.productImage,
        productPrice: widget.productPrice,
        reviewController: reviewController,
        onSubmitted: () {
          _refreshReviews();
        },
      ),
    );
  }

  void _showMyReviews() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: AppColors.primaryColor),
                  SizedBox(width: 12),
                  Text(
                    'My Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (reviewController.myReviews.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Reviews Yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start writing reviews to see them here',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: reviewController.myReviews.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = reviewController.myReviews[index];
                    return ReviewCardWidget(
                      review: review,
                      showProduct: true,
                      onEdit: () {
                        Get.back();
                        _editReview(review);
                      },
                      onDelete: () {
                        Get.back();
                        _deleteReview(review);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  bool _canEditReview(ReviewModel review) {
    final userReview = reviewController.getUserReviewForProduct(
      widget.productId,
    );
    return userReview != null && userReview.id == review.id;
  }

  bool _canDeleteReview(ReviewModel review) {
    final userReview = reviewController.getUserReviewForProduct(
      widget.productId,
    );
    return userReview != null && userReview.id == review.id;
  }

  void _editReview(ReviewModel review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewWidget(
        productId: widget.productId,
        productName: widget.productName,
        productImage: widget.productImage,
        productPrice: widget.productPrice,
        reviewController: reviewController,
        existingReview: review,
        isEdit: true,
        onSubmitted: () {
          _refreshReviews();
        },
      ),
    );
  }

  void _deleteReview(ReviewModel review) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.accentColor,
        title: Text(
          'Delete Review',
          style: TextStyle(color: AppColors.textColor),
        ),
        content: Text(
          'Are you sure you want to delete this review? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await reviewController.deleteReview(
                widget.productId,
              );
              if (success) {
                _refreshReviews();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
