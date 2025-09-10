import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:momentswrap/services/app_config.dart';

class ProductController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final AppConfig _appConfig = AppConfig();
  final RxBool isLoading = false.obs;
  final Rx<ProductResponse?> products = Rx<ProductResponse?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  // Categories for filtering
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  // Fetch all products (without filter/search)
  Future<void> fetchAllProducts() async {
    try {
      clearError();
      isLoading.value = true;

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: _appConfig.getListAllProducts,
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        List<dynamic> productsData;
        if (responseData is List) {
          productsData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          productsData = responseData['data'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format');
        }

        final productsList = productsData
            .map((json) {
              try {
                return ProductModel.fromJson(json);
              } catch (e) {
                print("Error parsing product: $e");
                return null;
              }
            })
            .where((product) => product != null)
            .cast<ProductModel>()
            .toList();

        products.value = ProductResponse(data: productsList);

        // Extract unique categories
        _extractCategories(productsList);
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching all products: $e");
      setError("Failed to load products. Please try again.");
      products.value = ProductResponse(data: []);
    } finally {
      isLoading.value = false;
    }
  }

  void _extractCategories(List<ProductModel> productsList) {
    final Set<String> uniqueCategories = {};
    for (var product in productsList) {
      if (product.category.isNotEmpty) {
        uniqueCategories.add(product.category);
      }
    }
    categories.value = uniqueCategories.toList()..sort();
  }

  // Get similar products (same category, different product)
  List<ProductModel> getSimilarProducts(
    String currentProductId,
    String category, {
    int limit = 10,
  }) {
    if (!hasProducts) return [];

    return productsList
        .where(
          (product) =>
              product.category.toLowerCase() == category.toLowerCase() &&
              product.id != currentProductId &&
              product.isActive,
        )
        .take(limit)
        .toList();
  }

  // Get products with valid offers/discounts
  List<ProductModel> getDiscountProducts({int limit = 10}) {
    if (!hasProducts) return [];

    return productsList
        .where(
          (product) =>
              product.offers.any(
                (offer) => offer.validTill.isAfter(DateTime.now()),
              ) &&
              product.isActive,
        )
        .take(limit)
        .toList();
  }

  // Get high-rating products (4+ stars)
  List<ProductModel> getHighRatingProducts({
    int limit = 10,
    double minRating = 4.0,
  }) {
    if (!hasProducts) return [];

    return productsList
        .where(
          (product) => product.averageRating >= minRating && product.isActive,
        )
        .toList()
      ..sort((a, b) => b.averageRating.compareTo(a.averageRating))
      ..take(limit);
  }

  // Get products with special offers
  List<ProductModel> getSpecialOfferProducts({int limit = 10}) {
    if (!hasProducts) return [];

    return productsList
        .where((product) => product.offers.isNotEmpty && product.isActive)
        .toList()
      ..sort(
        (a, b) => b.maxDiscountPercentage.compareTo(a.maxDiscountPercentage),
      )
      ..take(limit);
  }

  // Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    if (!hasProducts) return [];

    return productsList
        .where(
          (product) =>
              product.category.toLowerCase() == category.toLowerCase() &&
              product.isActive,
        )
        .toList();
  }

  // Get trending/popular products (based on reviews count and rating)
  List<ProductModel> getTrendingProducts({int limit = 10}) {
    if (!hasProducts) return [];

    return productsList.where((product) => product.isActive).toList()
      ..sort((a, b) {
        // Sort by combination of review count and rating
        double scoreA = (a.reviews.length * 0.3) + (a.averageRating * 0.7);
        double scoreB = (b.reviews.length * 0.3) + (b.averageRating * 0.7);
        return scoreB.compareTo(scoreA);
      })
      ..take(limit);
  }

  // Get recently added products
  List<ProductModel> getRecentProducts({int limit = 10}) {
    if (!hasProducts) return [];

    return productsList.where((product) => product.isActive).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
      ..take(limit);
  }

  // Get products in stock
  List<ProductModel> getInStockProducts({int limit = 10}) {
    if (!hasProducts) return [];

    return productsList
        .where((product) => product.stock > 0 && product.isActive)
        .take(limit)
        .toList();
  }

  // Get low stock products (for admin/alerts)
  List<ProductModel> getLowStockProducts({int threshold = 5}) {
    if (!hasProducts) return [];

    return productsList
        .where(
          (product) =>
              product.stock > 0 &&
              product.stock <= threshold &&
              product.isActive,
        )
        .toList();
  }

  // Search products by name, description, or category
  List<ProductModel> searchProducts(String query) {
    if (!hasProducts || query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();

    return productsList
        .where(
          (product) =>
              product.isActive &&
              (product.name.toLowerCase().contains(lowercaseQuery) ||
                  product.shortDescription.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  product.longDescription.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  product.category.toLowerCase().contains(lowercaseQuery) ||
                  product.material.toLowerCase().contains(lowercaseQuery)),
        )
        .toList();
  }

  // Filter products by multiple criteria
  List<ProductModel> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool? hasOffers,
  }) {
    if (!hasProducts) return [];

    var filtered = productsList.where((product) => product.isActive);

    if (category != null && category.isNotEmpty) {
      filtered = filtered.where(
        (p) => p.category.toLowerCase() == category.toLowerCase(),
      );
    }

    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice);
    }

    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice);
    }

    if (minRating != null) {
      filtered = filtered.where((p) => p.averageRating >= minRating);
    }

    if (inStockOnly == true) {
      filtered = filtered.where((p) => p.stock > 0);
    }

    if (hasOffers == true) {
      filtered = filtered.where(
        (p) => p.offers.any((offer) => offer.validTill.isAfter(DateTime.now())),
      );
    }

    return filtered.toList();
  }

  // Sort products by various criteria
  List<ProductModel> sortProducts(List<ProductModel> products, String sortBy) {
    final sortedList = List<ProductModel>.from(products);

    switch (sortBy.toLowerCase()) {
      case 'name':
      case 'name_asc':
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        sortedList.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price':
      case 'price_asc':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
      case 'rating_desc':
        sortedList.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case 'rating_asc':
        sortedList.sort((a, b) => a.averageRating.compareTo(b.averageRating));
        break;
      case 'newest':
      case 'date_desc':
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
      case 'date_asc':
        sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'popularity':
        sortedList.sort((a, b) {
          double scoreA = (a.reviews.length * 0.3) + (a.averageRating * 0.7);
          double scoreB = (b.reviews.length * 0.3) + (b.averageRating * 0.7);
          return scoreB.compareTo(scoreA);
        });
        break;
      case 'discount':
        sortedList.sort(
          (a, b) => b.maxDiscountPercentage.compareTo(a.maxDiscountPercentage),
        );
        break;
    }

    return sortedList;
  }

  // Get product by ID
  ProductModel? getProductById(String id) {
    if (!hasProducts) return null;

    try {
      return productsList.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get product recommendations based on user behavior (placeholder)
  List<ProductModel> getRecommendedProducts({int limit = 10}) {
    // This is a simple implementation. In a real app, you'd use user behavior data,
    // purchase history, viewed products, etc., to generate personalized recommendations.

    if (!hasProducts) return [];

    // For now, return a mix of trending and highly rated products
    final trending = getTrendingProducts(limit: limit ~/ 2);
    final highRated = getHighRatingProducts(limit: limit ~/ 2);

    final Set<String> addedIds = {};
    final List<ProductModel> recommendations = [];

    // Add trending products first
    for (var product in trending) {
      if (!addedIds.contains(product.id)) {
        recommendations.add(product);
        addedIds.add(product.id);
      }
    }

    // Fill remaining slots with high-rated products
    for (var product in highRated) {
      if (recommendations.length >= limit) break;
      if (!addedIds.contains(product.id)) {
        recommendations.add(product);
        addedIds.add(product.id);
      }
    }

    return recommendations;
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchAllProducts();
  }

  // Error Handling
  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  void setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  // Helper methods for UI
  bool get hasProducts =>
      products.value != null && products.value!.data.isNotEmpty;
  int get totalProducts => products.value?.data.length ?? 0;
  List<ProductModel> get productsList => products.value?.data ?? [];

  // Get statistics
  Map<String, dynamic> getProductStats() {
    if (!hasProducts) return {};

    final inStock = productsList.where((p) => p.stock > 0).length;
    final outOfStock = productsList.where((p) => p.stock == 0).length;
    final withOffers = productsList
        .where(
          (p) =>
              p.offers.any((offer) => offer.validTill.isAfter(DateTime.now())),
        )
        .length;
    final avgRating = productsList.isEmpty
        ? 0.0
        : productsList.map((p) => p.averageRating).reduce((a, b) => a + b) /
              productsList.length;

    return {
      'total': totalProducts,
      'inStock': inStock,
      'outOfStock': outOfStock,
      'withOffers': withOffers,
      'averageRating': avgRating,
      'categories': categories.length,
    };
  }
}
