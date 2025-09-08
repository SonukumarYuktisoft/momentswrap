import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/search_controller/search_product_controller.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:momentswrap/view/home_screen/product_card.dart';
import 'package:momentswrap/view/home_screen/product_detail_screen.dart';

class SearchAndFiltersBar extends StatefulWidget {
  SearchAndFiltersBar({Key? key}) : super(key: key);

  @override
  State<SearchAndFiltersBar> createState() => _SearchAndFiltersBarState();
}

class _SearchAndFiltersBarState extends State<SearchAndFiltersBar> {
  final SearchProductController controller = Get.put(SearchProductController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Delayed focus to avoid layout issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(searchFocusNode);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Filter bottom sheet method
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Center(child: Text('Filter options here'))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Search Bar Section
            Container(
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildSearchSuggestions(),
                  _buildActiveFilters(),
                ],
              ),
            ),

            // Scrollable Product List
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: true,
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: (value) {
          controller.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: "Search products, categories...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          prefixIcon: Obx(
            () => controller.isFiltering.value
                ? Container(
                    width: 20,
                    height: 20,
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.search, color: Colors.grey[600]),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clear search button
              Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          controller.updateSearchQuery('');
                          searchFocusNode.unfocus();
                        },
                        icon: Icon(Icons.clear, size: 20),
                      )
                    : SizedBox.shrink(),
              ),
              // Filter button
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () => showFilterBottomSheet(context),
                      icon: Icon(Icons.tune, color: Colors.grey[600]),
                    ),
                    // Filter indicator
                    Obx(
                      () => controller.hasActiveFilters()
                          ? Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Obx(() {
      if (controller.searchSuggestions.isEmpty ||
          !searchFocusNode.hasFocus ||
          searchController.text.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.searchSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = controller.searchSuggestions[index];
            return ListTile(
              dense: true,
              leading: Icon(Icons.search, size: 18, color: Colors.grey),
              title: Text(suggestion),
              onTap: () {
                searchController.text = suggestion;
                controller.applySuggestion(suggestion);
                searchFocusNode.unfocus();
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (!controller.hasActiveFilters()) return SizedBox.shrink();

      return Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // Category filter chip
            if (controller.selectedCategory.value != null)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(controller.selectedCategory.value!),
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: () => controller.selectCategory(null),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  deleteIconColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.blue),
                ),
              ),

            // Price range filter chip
            if (controller.minPrice.value > 0 ||
                controller.maxPrice.value < 10000)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(
                    '₹${controller.minPrice.value.toInt()} - ₹${controller.maxPrice.value.toInt()}',
                  ),
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: () => controller.updatePriceRange(0, 10000),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  deleteIconColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),

            // Stock filter chip
            if (controller.inStockOnly.value)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text('In Stock'),
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: () => controller.toggleStockFilter(),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  deleteIconColor: Colors.orange,
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),

            // Clear all filters button
            TextButton.icon(
              onPressed: controller.clearFilters,
              icon: Icon(Icons.clear_all, size: 16),
              label: Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductList() {
    return Obx(() {
      final productResponse = controller.products.value;

      if (controller.isLoading.value) {
        return Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      } else if (productResponse == null || productResponse.data.isEmpty) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  "No products available",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }

      return Scrollbar(
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // crossAxisCount: 2,
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = productResponse.data[index];
                  return ModernProductCard(
                    image: item.images.isNotEmpty ? item.images.first : '',
                    title: item.name,
                    subtitle: item.shortDescription,
                    price: "₹${item.price}",
                    // itemId: item.itemId,
                    offers: item.offers,
                    stock: item.stock,
                    showAddToCart: false,
                    // addToCart: () {
                    //   AuthUtils.runIfLoggedIn(() async {
                    //     await cartController.addToCart(
                    //       itemId: item.id,
                    //       quantity: 1,
                    //       image: item.images.isNotEmpty ? item.images.first : '',
                    //       totalPrice: item.price.toDouble(),
                    //     );
                    //   });
                    // },
                    onTap: () => Get.to(() => ProductDetailScreen(product: item),)
                  );
                }, childCount: productResponse.data.length),
              ),
            ),
          ],
        ),
      );
    });
  }
}
