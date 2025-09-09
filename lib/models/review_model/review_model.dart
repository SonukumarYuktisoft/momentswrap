class ReviewModel {
  final String id;
  final ProductInfo? product;
  final String customerId;
  final String customerName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    this.product,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      product: json['product'] != null ? ProductInfo.fromJson(json['product']) : null,
      customerId: json['customer']?['_id'] ?? json['customerId'] ?? '',
      customerName: json['customer']?['name'] ?? json['customerName'] ?? 'Anonymous User',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': product?.toJson(),
      'customerId': customerId,
      'customerName': customerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return difference.inMinutes <= 1 ? 'Just now' : '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  String get customerInitial {
    return customerName.isNotEmpty ? customerName[0].toUpperCase() : 'A';
  }

  bool get isRecent {
    return DateTime.now().difference(createdAt).inDays < 7;
  }

  ReviewModel copyWith({
    String? id,
    ProductInfo? product,
    String? customerId,
    String? customerName,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      product: product ?? this.product,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, customerName: $customerName, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class ProductInfo {
  final String id;
  final String name;
  final List<String> images;
  final double? price;

  ProductInfo({
    required this.id,
    required this.name,
    required this.images,
    this.price,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'images': images,
      'price': price,
    };
  }

  String get primaryImage {
    return images.isNotEmpty ? images.first : '';
  }

  String get formattedPrice {
    return price != null ? '₹${price!.toStringAsFixed(0)}' : 'Price not available';
  }

  @override
  String toString() {
    return 'ProductInfo(id: $id, name: $name, price: $price)';
  }
}

// Review Statistics Model for analytics
class ReviewStats {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final int recentReviews; // Reviews in last 30 days

  ReviewStats({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.recentReviews,
  });

  factory ReviewStats.fromReviews(List<ReviewModel> reviews) {
    final total = reviews.length;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    
    double average = 0.0;
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    int recent = 0;

    if (reviews.isNotEmpty) {
      double sum = 0;
      for (var review in reviews) {
        sum += review.rating;
        distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
        if (review.createdAt.isAfter(thirtyDaysAgo)) {
          recent++;
        }
      }
      average = sum / total;
    }

    return ReviewStats(
      totalReviews: total,
      averageRating: average,
      ratingDistribution: distribution,
      recentReviews: recent,
    );
  }

  String get formattedAverageRating {
    return averageRating.toStringAsFixed(1);
  }

  double getPercentageForRating(int rating) {
    if (totalReviews == 0) return 0.0;
    return ((ratingDistribution[rating] ?? 0) / totalReviews) * 100;
  }

  bool get hasReviews => totalReviews > 0;

  String get reviewCountText {
    if (totalReviews == 0) return 'No reviews';
    return '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}';
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'ratingDistribution': ratingDistribution,
      'recentReviews': recentReviews,
    };
  }
}