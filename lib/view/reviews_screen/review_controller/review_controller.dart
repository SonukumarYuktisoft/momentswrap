import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:Xkart/view/reviews_screen/review_model/review_model.dart';
import 'package:Xkart/services/api_services.dart';

class ReviewController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  // Observable variables
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var myReviews = <ReviewModel>[].obs;
  var productReviews = <ReviewModel>[].obs;

  // Error handling
  var errorMessage = ''.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize if needed
  }

  /// Get all reviews for a specific product
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiServices.getRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/product-reviews/$productId',
        authToken: false,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> reviewsJson = data['reviews'] ?? [];
          productReviews.value = reviewsJson
              .map((json) => ReviewModel.fromJson(json))
              .toList();
          return productReviews;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch reviews');
        }
      } else {
        throw Exception('Failed to fetch reviews');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load reviews: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Get my reviews (customer's own reviews)
  Future<List<ReviewModel>> getMyReviews() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiServices.getRequest(
        url: 'https://moment-wrap-backend.vercel.app/api/customer/my-reviews',
        authToken: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> reviewsJson = data['reviews'] ?? [];
          myReviews.value = reviewsJson
              .map((json) => ReviewModel.fromJson(json))
              .toList();
          return myReviews;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch your reviews');
        }
      } else if (response.statusCode == 404) {
        // No reviews found
        myReviews.value = [];
        return [];
      } else {
        throw Exception('Failed to fetch your reviews');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load your reviews: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new review
  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
    required String orderId,
  }) async {
    try {
      isSubmitting.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Validate inputs
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      if (comment.trim().isEmpty) {
        throw Exception('Review comment cannot be empty');
      }

      final response = await _apiServices.requestPostForApi(
        url: 'https://moment-wrap-backend.vercel.app/api/customer/add-review',
        authToken: true,
        dictParameter: {
          'rating': rating,
          'comment': comment.trim(),
          'orderId': orderId,
          'productId': productId,
        },
      );

      if (response != null &&
          (response.statusCode == 201 || response.statusCode == 200)) {
        final data = response.data ?? {};
        if (data['success'] == true) {
          Get.snackbar(
            'Success',
            'Review added successfully!',
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );

          // Refresh product reviews if we're viewing the same product
          await getProductReviews(productId);
          // return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to add review');
        }
      } else {
        final data = response?.data ?? {};
        throw Exception(data['message'] ?? 'Failed to add review');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      String errorMsg = 'Failed to add review';
      if (e.toString().contains('already reviewed')) {
        errorMsg = 'You have already reviewed this product';
      } else if (e.toString().contains('Rating must be')) {
        errorMsg = 'Please select a valid rating (1-5 stars)';
      } else if (e.toString().contains('comment cannot be empty')) {
        errorMsg = 'Please write a review comment';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
      // return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Update an existing review
  Future<void> updateReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    try {
      isSubmitting.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Validate inputs
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      if (comment.trim().isEmpty) {
        throw Exception('Review comment cannot be empty');
      }

      final response = await _apiServices.putRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/update-review/$productId',
        authToken: true,
        data: {'rating': rating, 'comment': comment.trim()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          Get.snackbar(
            'Success',
            'Review updated successfully!',
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );

          // // Refresh reviews
          // await getProductReviews(productId);
          // await getMyReviews();
          // return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to update review');
        }
      } else {
        final data = response.data;
        throw Exception(data['message'] ?? 'Failed to update review');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      String errorMsg = 'Failed to update review';
      if (e.toString().contains('not found')) {
        errorMsg =
            'Review not found or you don\'t have permission to update it';
      } else if (e.toString().contains('Rating must be')) {
        errorMsg = 'Please select a valid rating (1-5 stars)';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
      // return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Delete a review
  Future<bool> deleteReview(String productId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiServices.deleteRequest(
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/delete-review/$productId',
        authToken: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          Get.snackbar(
            'Success',
            'Review deleted successfully!',
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );

          // Refresh reviews
          await getProductReviews(productId);
          await getMyReviews();
          return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to delete review');
        }
      } else {
        final data = response.data;
        throw Exception(data['message'] ?? 'Failed to delete review');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      String errorMsg = 'Failed to delete review';
      if (e.toString().contains('not found')) {
        errorMsg = 'Review not found or already deleted';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate average rating from reviews list
  double calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;

    double total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  /// Get rating distribution for display
  Map<int, int> getRatingDistribution(List<ReviewModel> reviews) {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }

    return distribution;
  }

  /// Sort reviews by different criteria
  List<ReviewModel> sortReviews(List<ReviewModel> reviews, String sortBy) {
    List<ReviewModel> sortedList = List.from(reviews);

    switch (sortBy) {
      case 'newest':
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'highest_rating':
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'lowest_rating':
        sortedList.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      default:
        // Default to newest
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return sortedList;
  }

  /// Clear all data
  void clearData() {
    productReviews.clear();
    myReviews.clear();
    hasError.value = false;
    errorMessage.value = '';
  }

  /// Refresh product reviews
  Future<void> refreshProductReviews(String productId) async {
    await getProductReviews(productId);
  }

  /// Check if user has already reviewed a product
  bool hasUserReviewedProduct(String productId) {
    return myReviews.any(
      (review) => review.product != null && review.product!.id == productId,
    );
  }

  /// Get user's review for a specific product
  ReviewModel? getUserReviewForProduct(String productId) {
    try {
      return myReviews.firstWhere(
        (review) => review.product != null && review.product!.id == productId,
      );
    } catch (e) {
      return null;
    }
  }
}
