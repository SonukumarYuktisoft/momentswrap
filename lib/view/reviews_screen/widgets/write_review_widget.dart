import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Xkart/controllers/review_controller/review_controller.dart';
import 'package:Xkart/models/review_model/review_model.dart';
import 'package:Xkart/util/constants/app_colors.dart';

class WriteReviewWidget extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final ReviewController reviewController;
  final VoidCallback? onSubmitted;
  final ReviewModel? existingReview;
  final bool isEdit;

  const WriteReviewWidget({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.reviewController,
    this.onSubmitted,
    this.existingReview,
    this.isEdit = false,
  });

  @override
  State<WriteReviewWidget> createState() => _WriteReviewWidgetState();
}

class _WriteReviewWidgetState extends State<WriteReviewWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _commentController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _rating = 0;
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  // Rating descriptions
  final Map<int, String> _ratingDescriptions = {
    1: 'Poor',
    2: 'Fair',
    3: 'Good',
    4: 'Very Good',
    5: 'Excellent',
  };

  // Review suggestions based on rating
  final Map<int, List<String>> _reviewSuggestions = {
    5: [
      'Amazing product!',
      'Exceeded expectations',
      'Highly recommend',
      'Worth every penny',
    ],
    4: [
      'Great quality',
      'Very satisfied',
      'Good value for money',
      'Happy with purchase',
    ],
    3: [
      'Decent product',
      'As expected',
      'Average quality',
      'Okay for the price',
    ],
    2: [
      'Below expectations',
      'Could be better',
      'Not satisfied',
      'Some issues',
    ],
    1: ['Poor quality', 'Not recommended', 'Disappointed', 'Not worth it'],
  };

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
    _rating = widget.existingReview?.rating ?? 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Auto-focus on comment field if editing
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_rating == 0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating before submitting',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.star_outline, color: Colors.white),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      Get.snackbar(
        'Review Required',
        'Please write your review before submitting',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.edit_outlined, color: Colors.white),
      );
      return;
    }

    // bool success;
    // if (widget.isEdit) {
    //   success = await widget.reviewController.updateReview(
    //     productId: widget.productId,
    //     rating: _rating,
    //     comment: _commentController.text.trim(),
    //   );
    // }
    // //  else {
    // //   success = await widget.reviewController.addReview(
    // //     productId: widget.productId,
    // //     rating: _rating,
    // //     comment: _commentController.text.trim(),
    // //     orderId: widget.existingReview?.orderId ?? '',
    // //   );
  }

  //   if (success) {
  //     widget.onSubmitted?.call();
  //     Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Column(
                      children: [
                        _buildProductInfo(),
                        _buildRatingSection(),
                        _buildSuggestions(),
                        _buildCommentSection(),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                widget.isEdit ? Icons.edit : Icons.rate_review,
                color: AppColors.accentColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEdit ? 'Edit Your Review' : 'Write a Review',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentColor,
                      ),
                    ),
                    Text(
                      'Share your experience',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accentColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: AppColors.accentColor),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
            ),
            child: widget.productImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_outlined,
                          color: AppColors.textSecondary,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.image_outlined,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
          ),
          SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '₹${widget.productPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.05),
            AppColors.primaryColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            'How would you rate this product?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starRating = index + 1;
              final isSelected = starRating <= _rating;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = starRating;
                    _isExpanded = true;
                  });
                  // Haptic feedback
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: isSelected ? Colors.amber : Colors.grey[400],
                    size: isSelected ? 40 : 36,
                  ),
                ),
              );
            }),
          ),
          if (_rating > 0) ...[
            SizedBox(height: 8),
            AnimatedOpacity(
              opacity: _rating > 0 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getRatingColor(_rating).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getRatingColor(_rating).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _ratingDescriptions[_rating] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getRatingColor(_rating),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    if (_rating == 0) return SizedBox.shrink();

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded ? null : 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick suggestions:',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_reviewSuggestions[_rating] ?? []).map((suggestion) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_commentController.text.isEmpty) {
                        _commentController.text = suggestion;
                      } else {
                        _commentController.text += ' $suggestion';
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Review',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(' *', style: TextStyle(fontSize: 14, color: Colors.red)),
              Spacer(),
              Text(
                '${_commentController.text.length}/500',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.2),
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _commentController,
              focusNode: _focusNode,
              maxLines: 5,
              maxLength: 500,
              onChanged: (value) {
                setState(() {});
              },
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText:
                    'Share your experience with this product...\n\n• What did you like?\n• What could be improved?\n• Would you recommend it?',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withOpacity(0.6),
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isSubmitting = widget.reviewController.isSubmitting.value;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.accentColor,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: AppColors.primaryColor.withOpacity(0.3),
            disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.5),
          ),
          child: isSubmitting
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.accentColor,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isEdit ? Icons.update : Icons.send_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.isEdit ? 'Update Review' : 'Submit Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
