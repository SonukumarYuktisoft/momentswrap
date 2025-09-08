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
  @override
void initState() {
  super.initState();
  Future.delayed(Duration(milliseconds: 300), () {
    FocusScope.of(context).requestFocus(searchFocusNode);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Container(
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
                    autofocus: true,  // 👈
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
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
              ),
                
              // Search Suggestions
              Obx(() {
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
              }),
                
              // Active Filters Display
              Obx(() {
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
              }),
          
          
              // Expanded Product List
                Obx(() {
                        final productResponse = controller.products.value;
          
                        if (controller.isLoading.value) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        } else if (productResponse == null ||
                            productResponse.data.isEmpty) {
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
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
          
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.68,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: productResponse.data.length,
                            itemBuilder: (context, index) {
                              final item = productResponse.data[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ProductDetailScreen(product: item));
                                },
                                child: ModernProductCard(
                                  image: item.images.isNotEmpty
                                      ? item.images.first
                                      : '',
                                  title: item.name,
                                  subtitle: item.shortDescription,
                                  price: "₹${item.price}",
                                  offers: item.offers,
                                  stock: item.stock,
                                  // addToCart: (){
                                  //   AuthUtils.runIfLoggedIn(()async{
                                  //   await cartController.addToCart(
                                  //     productId: item.id,
                                  //     quantity: 1,
                                  //     image: item.images.isNotEmpty
                                  //         ? item.images.first
                                  //         : '',
                                  //     totalPrice: item.price.toDouble(),
                                  //   );
                                  //   });
          
                                  // },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                     
            ],
          ),
        ),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: HelperFunctions.screenHeight() * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Obx(
                      () => controller.hasActiveFilters()
                          ? TextButton(
                              onPressed: controller.clearFilters,
                              child: Text("Clear All"),
                            )
                          : SizedBox.shrink(),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Filters Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Filter
                      _buildFilterSection(
                        title: "Category",
                        child: Obx(() => _buildCategoryDropdown()),
                      ),

                      SizedBox(height: 24),

                      // Price Range Filter
                      _buildFilterSection(
                        title: "Price Range",
                        child: Obx(() => _buildPriceRangeSlider()),
                      ),

                      SizedBox(height: 24),

                      // Stock Filter
                      _buildFilterSection(
                        title: "Availability",
                        child: Obx(() => _buildStockFilter()),
                      ),
                    ],
                  ),
                ),
              ),

              // Apply Button
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () => controller.isFiltering.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Apply Filters",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: controller.selectedCategory.value,
        hint: Text('Select Category'),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        isExpanded: true,
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'All Categories',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ...controller.categories
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
        ],
        onChanged: (value) => controller.selectCategory(value),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(
            controller.minPrice.value,
            controller.maxPrice.value,
          ),
          min: 0,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            "₹${controller.minPrice.value.toInt()}",
            "₹${controller.maxPrice.value.toInt()}",
          ),
          onChanged: (RangeValues values) {
            controller.updatePriceRange(values.start, values.end);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text("₹${controller.minPrice.value.toInt()}"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text("₹${controller.maxPrice.value.toInt()}"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockFilter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: CheckboxListTile(
        title: Text("Show only in-stock items"),
        value: controller.inStockOnly.value,
        onChanged: (bool? value) {
          controller.toggleStockFilter();
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
