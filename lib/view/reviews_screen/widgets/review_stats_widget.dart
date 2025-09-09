import 'package:flutter/material.dart';
import 'package:momentswrap/models/review_model/review_model.dart';
import 'package:momentswrap/util/constants/app_colors.dart';

class ReviewStatsWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  final String productName;

  const ReviewStatsWidget({
    super.key,
    required this.reviews,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final stats = ReviewStats.fromReviews(reviews);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentColor,
            AppColors.accentColor.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16),

          if (stats.hasReviews) ...[
            // Main Stats Row
            Row(
              children: [
                // Overall Rating Section
                Expanded(
                  flex: 2,
                  child: _buildOverallRating(stats),
                ),
                SizedBox(width: 20),
                // Rating Distribution
                Expanded(
                  flex: 3,
                  child: _buildRatingDistribution(stats),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Additional Stats
            _buildAdditionalStats(stats),
          ] else ...[
            // _buildNoReviewsState(),
          ],
        ],
      )
    );
  }

  Widget _buildOverallRating(ReviewStats stats) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stats.formattedAverageRating,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < stats.averageRating.floor()
                    ? Icons.star_rounded
                    : index < stats.averageRating
                        ? Icons.star_half_rounded
                        : Icons.star_border_rounded,
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          SizedBox(height: 8),
          Text(
            stats.reviewCountText,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(ReviewStats stats) {
    return Column(
      children: [
        for (int i = 5; i >= 1; i--)
          _buildRatingBar(i, stats.ratingDistribution[i] ?? 0, stats.totalReviews),
      ],
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Star count
          SizedBox(
            width: 16,
            child: Text(
              '$stars',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          SizedBox(width: 8),
          
          // Progress bar
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          
          // Count
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalStats(ReviewStats stats) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.thumb_up_outlined,
            label: 'Positive',
            value: '${(stats.ratingDistribution[4] ?? 0) + (stats.ratingDistribution[5] ?? 0)}',
            // value: '${_getPositivePercentage(stats)}%',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.schedule_outlined,
            label: 'Recent',
            value: '${stats.recentReviews}',
            color: AppColors.primaryColor,
          ),
          _buildStatItem(
            icon: Icons.trending_up_outlined,
            label: 'Rating',
            value: stats.formattedAverageRating,
            color: Colors.amber[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Widget _buildNoReviewsState() {
  //   return Container(
  //     padding: EdgeInsets.all(24),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: AppColors.primaryColor.withOpacity(0.1),
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             Icons.rate_review_outlined,

          //  size: 32

}