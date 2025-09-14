import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:Xkart/models/product_models/product_model.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:Xkart/services/app_config.dart';

class ProductController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final AppConfig _appConfig = AppConfig();
  final RxBool isLoading = false.obs;
  final Rx<ProductResponse?> products = Rx<ProductResponse?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  // Categories for filtering
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'All'.obs; // Default to 'All'
  final Rx<ProductResponse?> filteredProducts = Rx<ProductResponse?>(null);
  final RxBool isCategoryLoading = false.obs;
  final RxBool isCategoriesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // Initialize data - fetch categories first, then products
  Future<void> initializeData() async {
    await Future.wait([fetchCategories(), fetchAllProducts()]);
  }

  // NEW: Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      clearError();

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url:
            'http://moment-wrap-backend.vercel.app/api/customer/list-products-by-category/', // Add this to your AppConfig
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        List<dynamic> categoriesData;
        if (responseData is List) {
          categoriesData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          categoriesData = responseData['data'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format for categories');
        }

        // Extract category names from the response
        final List<String> categoryNames = categoriesData
            .map((categoryJson) {
              if (categoryJson is String) {
                return categoryJson;
              } else if (categoryJson is Map) {
                // Assuming the API returns objects with 'name' field
                return categoryJson['name']?.toString() ?? '';
              }
              return '';
            })
            .where((name) => name.isNotEmpty)
            .toList();

        // Always include 'All' at the beginning
        final Set<String> uniqueCategories = {'All'};
        uniqueCategories.addAll(categoryNames);

        categories.value = uniqueCategories.toList();
        print(categories.value);

        // Keep 'All' at the beginning
        categories.sort((a, b) {
          if (a == 'All') return -1;
          if (b == 'All') return 1;
          return a.compareTo(b);
        });
      } else {
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      // Fallback to default categories

      setError("Failed to load categories. Using default.");
    } finally {
      isCategoriesLoading.value = false;
    }
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
        filteredProducts.value = ProductResponse(data: productsList);

        // If "All" is selected, show all products, otherwise maintain current filter
        if (selectedCategory.value == 'All') {
          filteredProducts.value = ProductResponse(data: productsList);
        }

        // Extract unique categories from products and update categories.value
        final Set<String> uniqueCategories = {'All'};
        for (var product in productsList) {
          if (product.category.isNotEmpty) {
            uniqueCategories.add(product.category);
          }
        }
        categories.value = uniqueCategories.toList();
        // Keep 'All' at the beginning
        categories.sort((a, b) {
          if (a == 'All') return -1;
          if (b == 'All') return 1;
          return a.compareTo(b);
        });
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching all products: $e");
      setError("Failed to load products. Please try again.");
      products.value = ProductResponse(data: []);
      filteredProducts.value = ProductResponse(data: []);
      categories.value = ['All'];
    } finally {
      isLoading.value = false;
    }
  }

  // NEW: Fetch products by category using POST API
  Future<void> fetchProductsByCategory(String category) async {
    // Update UI immediately - this gives instant feedback
    selectedCategory.value = category;

    if (category == 'All') {
      // Show all products
      filteredProducts.value = products.value;
      return;
    }

    try {
      isCategoryLoading.value = true;
      clearError();

      // Prepare POST request body
      Map<String, dynamic> requestBody = {
        'category': category,
        // Add other filter parameters if needed
      };

      final dio.Response? response = await _apiServices.requestPostForApi(
        authToken: false,
        url:
            'http://moment-wrap-backend.vercel.app/filter-products?', // POST endpoint for filtering
        dictParameter: requestBody,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final dynamic responseData = response?.data;

        List<dynamic> productsData;
        if (responseData is List) {
          productsData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          productsData = responseData['data'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format');
        }

        final categoryProductsList = productsData
            .map((json) {
              try {
                return ProductModel.fromJson(json);
              } catch (e) {
                print("Error parsing category product: $e");
                return null;
              }
            })
            .where((product) => product != null)
            .cast<ProductModel>()
            .toList();

        filteredProducts.value = ProductResponse(data: categoryProductsList);
      } else {
        throw Exception(
          "Failed to load category products: ${response?.statusCode}",
        );
      }
    } catch (e) {
      print("Error fetching products by category: $e");
      setError("Failed to load category products. Please try again.");
      // Fallback to local filtering if API fails
      _filterProductsLocally(category);
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // NEW: Filter products using POST API with multiple parameters
  Future<void> filterProductsAPI({
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    String? sortBy,
  }) async {
    try {
      isCategoryLoading.value = true;
      clearError();

      // Build request body for POST
      Map<String, dynamic> requestBody = {};

      if (category != null && category != 'All') {
        requestBody['category'] = category;
      }
      if (minPrice != null) {
        requestBody['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        requestBody['maxPrice'] = maxPrice;
      }
      if (minStock != null) {
        requestBody['minStock'] = minStock;
      }
      if (sortBy != null) {
        requestBody['sortBy'] = sortBy;
      }

      final dio.Response? response = await _apiServices.requestPostForApi(
        authToken: false,
        url: '',
        dictParameter: requestBody,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        final dynamic responseData = response?.data;

        List<dynamic> productsData;
        if (responseData is List) {
          productsData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          productsData = responseData['data'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format');
        }

        final filteredProductsList = productsData
            .map((json) {
              try {
                return ProductModel.fromJson(json);
              } catch (e) {
                print("Error parsing filtered product: $e");
                return null;
              }
            })
            .where((product) => product != null)
            .cast<ProductModel>()
            .toList();

        filteredProducts.value = ProductResponse(data: filteredProductsList);
        if (category != null) {
          selectedCategory.value = category;
        }
      } else {
        throw Exception("Failed to filter products: ${response?.statusCode}");
      }
    } catch (e) {
      print("Error filtering products: $e");
      setError("Failed to filter products. Please try again.");
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // Local fallback filtering (when API fails)
  void _filterProductsLocally(String category) {
    if (!hasProducts) return;

    if (category == 'All') {
      filteredProducts.value = products.value;
    } else {
      final filtered = productsList
          .where(
            (product) =>
                product.category.toLowerCase() == category.toLowerCase() &&
                product.isActive,
          )
          .toList();

      filteredProducts.value = ProductResponse(data: filtered);
    }
  }

  // Extract categories from products (fallback method)
  void _extractCategoriesFromProducts(List<ProductModel> productsList) {
    final Set<String> uniqueCategories = {'All'}; // Always include 'All' option
    for (var product in productsList) {
      if (product.category.isNotEmpty) {
        uniqueCategories.add(product.category);
      }
    }
    categories.value = uniqueCategories.toList();
    // Keep 'All' at the beginning
    categories.sort((a, b) {
      if (a == 'All') return -1;
      if (b == 'All') return 1;
      return a.compareTo(b);
    });
  }

  // NEW: Method to handle category selection with instant UI feedback
  void selectCategory(String category) {
    if (selectedCategory.value == category) return; // Already selected

    // Instant UI update - this is key for good UX
    selectedCategory.value = category;

    // Then fetch data in background
    fetchProductsByCategory(category);
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
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    return sourceList
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
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    final filtered = sourceList
        .where(
          (product) => product.averageRating >= minRating && product.isActive,
        )
        .toList();

    filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return filtered.take(limit).toList();
  }

  // Get products with special offers
  List<ProductModel> getSpecialOfferProducts({int limit = 10}) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    final filtered = sourceList
        .where((product) => product.offers.isNotEmpty && product.isActive)
        .toList();

    filtered.sort(
      (a, b) => b.maxDiscountPercentage.compareTo(a.maxDiscountPercentage),
    );
    return filtered.take(limit).toList();
  }

  // Get products by category (now uses filtered products)
  List<ProductModel> getProductsByCategory(String category) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    if (category == 'All') {
      return sourceList.where((product) => product.isActive).toList();
    }

    return sourceList
        .where(
          (product) =>
              product.category.toLowerCase() == category.toLowerCase() &&
              product.isActive,
        )
        .toList();
  }

  // Get trending/popular products (based on reviews count and rating)
  List<ProductModel> getTrendingProducts({int limit = 10}) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    final filtered = sourceList.where((product) => product.isActive).toList();
    filtered.sort((a, b) {
      // Sort by combination of review count and rating
      double scoreA = (a.reviews.length * 0.3) + (a.averageRating * 0.7);
      double scoreB = (b.reviews.length * 0.3) + (b.averageRating * 0.7);
      return scoreB.compareTo(scoreA);
    });
    return filtered.take(limit).toList();
  }

  // Get recently added products
  List<ProductModel> getRecentProducts({int limit = 10}) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    final filtered = sourceList.where((product) => product.isActive).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered.take(limit).toList();
  }

  // Get products in stock
  List<ProductModel> getInStockProducts({int limit = 10}) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    return sourceList
        .where((product) => product.stock > 0 && product.isActive)
        .take(limit)
        .toList();
  }

  // Get low stock products (for admin/alerts)
  List<ProductModel> getLowStockProducts({int threshold = 5}) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    return sourceList
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
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty || query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();

    return sourceList
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

  // Filter products by multiple criteria (now uses API first, falls back to local)
  List<ProductModel> filterProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool? hasOffers,
  }) {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

    var filtered = sourceList.where((product) => product.isActive);

    if (category != null && category.isNotEmpty && category != 'All') {
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

    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return [];

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
    await initializeData();
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

  bool get hasFilteredProducts =>
      filteredProducts.value != null && filteredProducts.value!.data.isNotEmpty;

  bool get hasCategories => categories.isNotEmpty;

  int get totalProducts => products.value?.data.length ?? 0;

  int get filteredProductsCount => filteredProducts.value?.data.length ?? 0;

  List<ProductModel> get productsList => products.value?.data ?? [];

  List<ProductModel> get filteredProductsList =>
      filteredProducts.value?.data ?? [];

  // Get statistics
  Map<String, dynamic> getProductStats() {
    final sourceList = filteredProducts.value?.data ?? productsList;
    if (sourceList.isEmpty) return {};

    final inStock = sourceList.where((p) => p.stock > 0).length;
    final outOfStock = sourceList.where((p) => p.stock == 0).length;
    final withOffers = sourceList
        .where(
          (p) =>
              p.offers.any((offer) => offer.validTill.isAfter(DateTime.now())),
        )
        .length;
    final avgRating = sourceList.isEmpty
        ? 0.0
        : sourceList.map((p) => p.averageRating).reduce((a, b) => a + b) /
              sourceList.length;

    return {
      'total': sourceList.length,
      'inStock': inStock,
      'outOfStock': outOfStock,
      'withOffers': withOffers,
      'averageRating': avgRating,
      'categories': categories.length,
    };
  }
}
