import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/services/api_services.dart';
import 'package:dio/dio.dart' as dio;

import 'dart:async';

class ProductController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final RxBool isLoading = false.obs;
  final RxBool isFiltering = false.obs;
  final Rx<ProductResponse?> products = Rx<ProductResponse?>(null);
  final Rx<ProductResponse?> allProducts = Rx<ProductResponse?>(null); // Store all products
  final RxList<String> categories = <String>[].obs;
  final RxList<String> selectedTags = <String>[].obs;
  final Rx<String?> selectedCategory = Rx<String?>(null);

  final RxString searchQuery = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxBool inStockOnly = false.obs;
  final RxList<String> searchSuggestions = <String>[].obs;

  // Debouncer for search
  Timer? _searchDebouncer;
  final Duration _searchDebounceDelay = const Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts(); // Fetch all products first
    Get.put(CartController());
    
    // Listen to search query changes for debouncing
    ever(searchQuery, (_) => _debounceSearch());
  }

  @override
  void onClose() {
    _searchDebouncer?.cancel();
    super.onClose();
  }

  // Fetch all products and extract categories
  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    try {
      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/list-all-products',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> responseData = response.data;
        final productResponse = ProductResponse(
          data: responseData
              .map((json) => ProductModel.fromJson(json))
              .toList(),
        );
        
        // Store all products
        allProducts.value = productResponse;
        products.value = productResponse;
        
        // Extract categories from all products
        extractCategories();
      }
    } catch (e) {
      print('Error fetching all products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Extract unique categories from products
  void extractCategories() {
    if (allProducts.value != null) {
      final categoriesList = allProducts.value!.data
          .map((product) => product.category)
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList();
      
      categories.value = categoriesList;
      print('Categories extracted: ${categories.value}');
    }
  }

  // Get product details by ID
  Future<ProductModel?> getProductDetails(String productId) async {
    try {
      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/get-product-details/$productId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
    return null;
  }

  // Get products by category
  Future<void> getProductsByCategory(String category) async {
    isFiltering.value = true;
    try {
      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/list-products-by-category/$category',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> responseData = response.data;
        products.value = ProductResponse(
          data: responseData
              .map((json) => ProductModel.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      print('Error fetching products by category: $e');
    } finally {
      isFiltering.value = false;
    }
  }

  // Filter products using API
  Future<void> filterProducts() async {
    isFiltering.value = true;
    try {
      Map<String, dynamic> queryParameters = {};
      
      // Add price range if not default
      if (minPrice.value > 0) {
        queryParameters['minPrice'] = minPrice.value.toInt();
      }
      if (maxPrice.value < 10000) {
        queryParameters['maxPrice'] = maxPrice.value.toInt();
      }
      
      // Add category filter
      if (selectedCategory.value != null && selectedCategory.value!.isNotEmpty) {
        queryParameters['category'] = selectedCategory.value;
      }
      
      // Add stock filter
      if (inStockOnly.value) {
        queryParameters['inStock'] = true;
      }

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moment-wrap-backend.vercel.app/api/customer/filter-products',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> responseData = response.data;
        products.value = ProductResponse(
          data: responseData
              .map((json) => ProductModel.fromJson(json))
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
    if (allProducts.value == null) return;

    List<ProductModel> filteredProducts = List.from(allProducts.value!.data);

    // Apply search query filter
    if (searchQuery.value.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               product.shortDescription.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               product.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (selectedCategory.value != null && selectedCategory.value!.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.category == selectedCategory.value;
      }).toList();
    }

    // Apply price range filter
    filteredProducts = filteredProducts.where((product) {
      return product.price >= minPrice.value && product.price <= maxPrice.value;
    }).toList();

    // Apply stock filter
    if (inStockOnly.value) {
      filteredProducts = filteredProducts.where((product) {
        return product.stock > 0;
      }).toList();
    }

    products.value = ProductResponse(data: filteredProducts);
  }

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
        } else {
          products.value = allProducts.value;
        }
      }
    });
  }

  // Generate search suggestions
  void generateSearchSuggestions() {
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
  }

  // Check if any filters are active
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
}