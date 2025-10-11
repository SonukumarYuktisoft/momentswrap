import 'package:Xkart/view/reviews_screen/review_model/review_model.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback? onTap;

  const ReviewCard({super.key, required this.review, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer info row
              Row(
                children: [
                  // Customer avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      review.customerInitial,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Customer name and rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Rating container
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${review.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Rating text (Very Good, etc.)
              Text(
                _getRatingText(review.rating),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Review comment
              Text(
                review.comment,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Date
              Text(
                review.formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Very Good';
      case 3:
        return 'Good';
      case 2:
        return 'Fair';
      case 1:
        return 'Poor';
      default:
        return 'Not Rated';
    }
  }
}