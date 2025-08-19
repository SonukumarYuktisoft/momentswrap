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
  final Rx<ProductModel?> products = Rx<ProductModel?>(null);
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
    fetchProducts();
    fetchCategories();
    Get.put(CartController());
  }

  @override
  void onClose() {
    _searchDebouncer?.cancel();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      // if (inStockOnly.value) {
      //   queryParameters['inStock'] = true;
      // }

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
        // queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Response Data: ${response.data}");
        final responseData = ProductModel.fromJson(response.data);
        products.value = responseData;
        categories.value =
            responseData.data
                ?.map((product) => product.category ?? '')
                .where((category) => category.isNotEmpty)
                .toSet()
                .toList() ??
            [];

        print(categories.value.length.toString());
        print(products.value);
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> queryParameters = {};

      if (searchQuery.value.isNotEmpty) {
        queryParameters['search'] = searchQuery.value;
      }
      if (selectedCategory.value != null &&
          selectedCategory.value!.isNotEmpty) {
        queryParameters['category'] = selectedCategory.value;
      }

      queryParameters['price'] = {'min': minPrice.value, 'max': maxPrice.value};

      // if (inStockOnly.value) {
      //   queryParameters['inStock'] = true;
      // }

      final dio.Response response = await _apiServices.getRequest(
        authToken: false,
        url: 'https://moments-wrap-backend.vercel.app/product/getAllProducts',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Response Data: ${response.data}");
        final responseData = ProductModel.fromJson(response.data);
        products.value = responseData;
        // categories.value =
        //     responseData.data
        //         ?.map((product) => product.category ?? '')
        //         .where((category) => category.isNotEmpty)
        //         .toSet()
        //         .toList() ??
        //     [];
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;

    // Cancel previous debouncer if active
    _searchDebouncer?.cancel();

    // Start new debouncer
    _searchDebouncer = Timer(_searchDebounceDelay, () {
      if (query.isEmpty) {
        searchSuggestions.clear();
      } else {
        updateSearchSuggestions(query);
      }
      fetchProducts();
    });
  }

  void updateSearchSuggestions(String query) {
    if (products.value?.data == null) return;

    searchSuggestions.value = products.value!.data!
        .where(
          (product) =>
              product.name?.toLowerCase().contains(query.toLowerCase()) ??
              false,
        )
        .map((product) => product.name!)
        .take(5)
        .toList();
  }

  void applyFilters({
    String? search,
    String? category,
    double? min,
    double? max,
    // bool? inStock,
  }) {
    // Cancel any pending search debounce
    _searchDebouncer?.cancel();

    if (search != null) searchQuery.value = search;
    if (category != null) selectedCategory.value = category;
    if (min != null) minPrice.value = min;
    if (max != null) maxPrice.value = max;
    // if (inStock != null) inStockOnly.value = inStock;

    fetchProducts();
  }

  void clearFilters() {
    // Cancel any pending search debounce
    _searchDebouncer?.cancel();

    searchQuery.value = '';
    selectedCategory.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
    inStockOnly.value = false;
    searchSuggestions.clear();
    fetchProducts();
  }
  void clearCategories() {
    categories.clear();
  }
}
