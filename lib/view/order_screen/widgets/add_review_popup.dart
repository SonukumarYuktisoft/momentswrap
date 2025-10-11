import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/reviews_screen/review_controller/review_controller.dart';
import 'package:Xkart/util/constants/app_colors.dart';

class AddReviewPopup extends StatefulWidget {
  final String productName;
  final String orderId;
  final String productImageUrl;
  final Function(int rating, String comment) onSubmit;

  const AddReviewPopup({
    super.key,
    required this.productName,
    required this.orderId,
    required this.productImageUrl,
    required this.onSubmit,
  });

  @override
  State<AddReviewPopup> createState() => _AddReviewPopupState();
}

class _AddReviewPopupState extends State<AddReviewPopup> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final int _maxChars = 500;

  final ReviewController _reviewController = Get.find();

  // Check if form is valid (rating is required, comment is also required now)
  bool get _isFormValid =>
      _rating > 0 && _commentController.text.trim().isNotEmpty;

  void _showValidationSnackbar() {
    Get.snackbar(
      'Validation Error',
      'Please provide both rating and comment to submit your review',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _submitReview() async {
    if (!_isFormValid) {
      _showValidationSnackbar();
      return;
    }

    try {
      await widget.onSubmit(_rating, _commentController.text.trim());

      // Show success message
      Get.snackbar(
        'Success',
        'Your review has been submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Close popup after successful submission
      Navigator.pop(context);
    } catch (e) {
      // Show error message if submission fails
      Get.snackbar(
        'Error',
        'Failed to submit review. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Review",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Share your experience with this product",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 16),

              /// Product info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.productImageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Order #${widget.orderId}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Rating
              const Text(
                "Rating *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  int starIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // If same star is clicked, unselect it, otherwise select it
                        if (_rating == starIndex) {
                          _rating = 0; // Unselect current rating
                        } else {
                          _rating = starIndex; // Select new rating
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        _rating >= starIndex ? Icons.star : Icons.star_border,
                        color: _rating >= starIndex
                            ? Colors.amber
                            : Colors.grey[400],
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),
              if (_rating > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _rating == 1
                        ? "Poor"
                        : _rating == 2
                        ? "Fair"
                        : _rating == 3
                        ? "Good"
                        : _rating == 4
                        ? "Very Good"
                        : "Excellent",
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),

              /// Comment
              const SizedBox(height: 20),
              const Text(
                "Comment *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLength: _maxChars,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {}); // Rebuild to update submit button state
                },
                decoration: InputDecoration(
                  hintText: "Share your experience with this product...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  counterText: '${_commentController.text.length}/$_maxChars',
                ),
              ),

              /// Buttons
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close popup
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          (_isFormValid &&
                              !_reviewController.isSubmitting.value)
                          ? _submitReview
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? AppColors.primaryColor
                            : Colors.grey[300],
                        foregroundColor: _isFormValid
                            ? Colors.white
                            : Colors.grey[600],
                        elevation: _isFormValid ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
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
                          : const Text(
                              "Submit Review",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
