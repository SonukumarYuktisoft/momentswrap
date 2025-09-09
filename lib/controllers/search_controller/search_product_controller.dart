import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:dio/dio.dart' as dio;

import 'dart:async';

class SearchProductController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final RxBool isLoading = false.obs;
  final RxBool isFiltering = false.obs;
  final Rx<ProductResponse?> products = Rx<ProductResponse?>(null);
  final Rx<ProductResponse?> allProducts = Rx<ProductResponse?>(null);
  final RxList<String> categories = <String>[].obs;
  final RxList<String> selectedTags = <String>[].obs;
  final Rx<String?> selectedCategory = Rx<String?>(null);

  final RxString searchQuery = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxBool inStockOnly = false.obs;
  final RxList<String> searchSuggestions = <String>[].obs;

  // Error handling
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  // Debouncer for search
  Timer? _searchDebouncer;
  final Duration _searchDebounceDelay = const Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();

    // Initialize cart controller safely
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    // Listen to search query changes for debouncing
    ever(searchQuery, (_) => _debounceSearch());
  }

  @override
  void onClose() {
    _searchDebouncer?.cancel();
    super.onClose();
  }

  // Clear error state
  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }

  // Set error state
  void setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  // Fetch all products and extract categories
  Future<void> fetchAllProducts() async {
    try {
      clearError();
      isLoading.value = true;

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/list-all-products',
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        // Handle both List and single object responses
        List<dynamic> productsData;
        if (responseData is List) {
          productsData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          productsData = responseData['data'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format');
        }

        final productResponse = ProductResponse(
          data: productsData
              .map((json) {
                try {
                  return ProductModel.fromJson(json);
                } catch (e) {
                  print('Error parsing product: $e');
                  print('Product JSON: $json');
                  return null;
                }
              })
              .where((product) => product != null)
              .cast<ProductModel>()
              .toList(),
        );

        // Store all products
        allProducts.value = productResponse;
        products.value = productResponse;

        // Extract categories from all products
        extractCategories();

        print('Successfully fetched ${productResponse.data.length} products');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all products: $e');
      setError('Failed to load products. Please try again.');

      // Set empty response on error
      allProducts.value = ProductResponse(data: []);
      products.value = ProductResponse(data: []);
    } finally {
      isLoading.value = false;
    }
  }

  // Extract unique categories from products
  void extractCategories() {
    try {
      if (allProducts.value != null && allProducts.value!.data.isNotEmpty) {
        final categoriesList = allProducts.value!.data
            .map((product) => product.category)
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList();

        categories.value = categoriesList;
        print('Categories extracted: ${categories.value}');
      }
    } catch (e) {
      print('Error extracting categories: $e');
    }
  }

  // Get product details by ID
  Future<ProductModel?> getProductDetails(String productId) async {
    try {
      clearError();

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/get-product-details/$productId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;

        if (responseData.containsKey('data')) {
          return ProductModel.fromJson(responseData['data']);
        } else {
          return ProductModel.fromJson(responseData);
        }
      }
    } catch (e) {
      print('Error fetching product details: $e');
      setError('Failed to load product details.');
    }
    return null;
  }

  // Get products by category
  Future<void> getProductsByCategory(String category) async {
    try {
      clearError();
      isFiltering.value = true;

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/list-products-by-category/$category',
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

        products.value = ProductResponse(
          data: productsData
              .map((json) {
                try {
                  return ProductModel.fromJson(json);
                } catch (e) {
                  print('Error parsing product in category: $e');
                  return null;
                }
              })
              .where((product) => product != null)
              .cast<ProductModel>()
              .toList(),
        );
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      setError('Failed to load products for category: $category');
      // Fallback to local filtering
      applyLocalFilters();
    } finally {
      isFiltering.value = false;
    }
  }

  // Filter products using API
  Future<void> filterProducts() async {
    try {
      clearError();
      isFiltering.value = true;

      Map<String, dynamic> queryParameters = {};

      // Add price range if not default
      if (minPrice.value > 0) {
        queryParameters['minPrice'] = minPrice.value.toInt();
      }
      if (maxPrice.value < 10000) {
        queryParameters['maxPrice'] = maxPrice.value.toInt();
      }

      // Add category filter
      if (selectedCategory.value != null &&
          selectedCategory.value!.isNotEmpty) {
        queryParameters['category'] = selectedCategory.value;
      }

      // Add stock filter
      if (inStockOnly.value) {
        queryParameters['inStock'] = true;
      }

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url:
            'https://moment-wrap-backend.vercel.app/api/customer/filter-products',
        queryParameters: queryParameters,
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

        products.value = ProductResponse(
          data: productsData
              .map((json) {
                try {
                  return ProductModel.fromJson(json);
                } catch (e) {
                  print('Error parsing filtered product: $e');
                  return null;
                }
              })
              .where((product) => product != null)
              .cast<ProductModel>()
              .toList(),
        );
      }
    } catch (e) {
      print('Error filtering products: $e');
      // Fallback to local filtering if API fails
      applyLocalFilters();
    } finally {
      isFiltering.value = false;
    }
  }

  // Apply local filters as fallback
  void applyLocalFilters() {
    try {
      if (allProducts.value == null) return;

      List<ProductModel> filteredProducts = List.from(allProducts.value!.data);

      // Apply search query filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        filteredProducts = filteredProducts.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.shortDescription.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query) ||
              product.longDescription.toLowerCase().contains(query);
        }).toList();
      }

      // Apply category filter
      if (selectedCategory.value != null &&
          selectedCategory.value!.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.category == selectedCategory.value;
        }).toList();
      }

      // Apply price range filter
      filteredProducts = filteredProducts.where((product) {
        return product.price >= minPrice.value &&
            product.price <= maxPrice.value;
      }).toList();

      // Apply stock filter
      if (inStockOnly.value) {
        filteredProducts = filteredProducts.where((product) {
          return product.stock > 0;
        }).toList();
      }

      products.value = ProductResponse(data: filteredProducts);
    } catch (e) {
      print('Error applying local filters: $e');
      setError('Error filtering products');
    }
  }

  // Debounced search functionality
  // void _debounceSearch() {
  //   _searchDebouncer?.cancel();
  //   _searchDebouncer = Timer(_searchDebounceDelay, () {
  //     if (searchQuery.value.isNotEmpty) {
  //       generateSearchSuggestions();
  //       applyLocalFilters();
  //     } else {
  //       searchSuggestions.clear();
  //       if (hasActiveFilters()) {
  //         applyLocalFilters();
  //       } else {
  //         products.value = allProducts.value;
  //       }
  //     }
  //   });
  // }
  // Debounced search functionality
void _debounceSearch() {
  _searchDebouncer?.cancel();
  _searchDebouncer = Timer(_searchDebounceDelay, () {
    if (searchQuery.value.isNotEmpty) {
      generateSearchSuggestions();
      applyLocalFilters();
    } else {
      searchSuggestions.clear();
      if (hasActiveFilters()) {
        applyLocalFilters();
      } else if (searchQuery.value.isNotEmpty) {
        // Agar query hai to filter lagao
        applyLocalFilters();
      } else {
        // Bilkul fresh case me hi reset karo
        products.value = allProducts.value;
      }
    }
  });
}


  // Generate search suggestions
  void generateSearchSuggestions() {
    try {
      if (allProducts.value == null || searchQuery.value.isEmpty) {
        searchSuggestions.clear();
        return;
      }

      final query = searchQuery.value.toLowerCase();
      final suggestions = <String>{};

      for (var product in allProducts.value!.data) {
        if (product.name.toLowerCase().contains(query)) {
          suggestions.add(product.name);
        }
        if (product.category.toLowerCase().contains(query)) {
          suggestions.add(product.category);
        }
      }

      searchSuggestions.value = suggestions.take(5).toList();
    } catch (e) {
      print('Error generating search suggestions: $e');
    }
  }

  bool hasActiveFilters() {
    return selectedCategory.value != null ||
        minPrice.value > 0 ||
        maxPrice.value < 10000 ||
        inStockOnly.value ||
        searchQuery.value.isNotEmpty;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Apply suggestion
  void applySuggestion(String suggestion) {
    searchQuery.value = suggestion;
    searchSuggestions.clear();
  }

  // Clear all filters
  void clearFilters() {
    selectedCategory.value = null;
    searchQuery.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
    inStockOnly.value = false;
    selectedTags.clear();
    searchSuggestions.clear();
    products.value = allProducts.value;
    clearError();
  }

  // Apply filters (called from UI)
  void applyFilters() {
    if (hasActiveFilters()) {
      filterProducts(); // Use API filtering first
    } else {
      products.value = allProducts.value;
    }
  }

  // Category selection handler
  void selectCategory(String? category) {
    selectedCategory.value = category;
    if (category != null && category.isNotEmpty) {
      getProductsByCategory(category);
    } else {
      applyFilters();
    }
  }

  // Price range update
  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  // Toggle stock filter
  void toggleStockFilter() {
    inStockOnly.value = !inStockOnly.value;
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchAllProducts();
  }

  // Helper methods for UI
  bool get hasProducts =>
      products.value != null && products.value!.data.isNotEmpty;

  int get totalProducts => products.value?.data.length ?? 0;

  List<ProductModel> get productsList => products.value?.data ?? [];
}
