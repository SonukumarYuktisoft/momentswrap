import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:momentswrap/controllers/product_controller/product_controller.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';

class SearchAndFiltersBar extends StatelessWidget {
  final ProductController controller = Get.find();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: searchController,
          focusNode: searchFocusNode,
          decoration: InputDecoration(
            hintText: "Search products...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            prefixIcon: IconButton(
              onPressed: () {
                // showbtm();
              },

              icon: Icon(Icons.search),
            ),
            suffixIcon: IconButton(
              onPressed: () => showSearchBottomSheet(),

              icon: Icon(Icons.filter_list),
            ),
          ),
        ),
        // Search suggestions
        Obx(() {
          if (controller.searchSuggestions.isEmpty ||
              !searchFocusNode.hasFocus ||
              searchController.text.isEmpty) {
            return SizedBox.shrink();
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void showSearchBottomSheet() {
    final controller = Get.find<ProductController>();

    Get.bottomSheet(
      ClipPath(
        child: Container(
          height: HelperFunctions.screenHeight() * 0.7,
          width: HelperFunctions.screenWidth(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Filters",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Category Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  return _companyDropDown(
                    onChanged: (p0) async {
                      controller.selectedCategory.value = p0!;

                      await controller.fetchProducts();
                    },

                    items: controller.categories,

                    value: controller.selectedCategory.value,
                  );
                }),
              ),

              // OutlinedButton(onPressed: controller.clearCategories, child: Text('Clear')),

              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     controller.clearFilters();
              //   },
              //   child: Text("Clear"),
              // ),

              // Price Range Slider
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Obx(() {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Price Range",
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              // RangeSlider(
              //   values: RangeValues(
              //     controller.minPrice.value,
              //     controller.maxPrice.value,
              //   ),
              //   min: 0,
              //   max: 10000,
              //   divisions: 20,
              //   labels: RangeLabels(
              //     "₹${controller.minPrice.value.toInt()}",
              //     "₹${controller.maxPrice.value.toInt()}",
              //   ),
              //   onChanged: (RangeValues values) {
              //     controller.minPrice.value = values.start;
              //     controller.maxPrice.value = values.end;
              //   },
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("₹${controller.minPrice.value.toInt()}"),
              //     Text("₹${controller.maxPrice.value.toInt()}"),
              //   ],
              // ),
            ],

            // SizedBox(height: 20),

            // // In Stock Only Checkbox
            // Obx(
            //   () => CheckboxListTile(
            //     title: Text("In Stock Only"),
            //     value: controller.inStockOnly.value,
            //     onChanged: (bool? value) {
            //       controller.inStockOnly.value = value ?? false;
            //     },
            //   ),
            // ),

            // Spacer(),

            // // Apply and Clear Buttons
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: () {

            //           },
            //           child: Text("Apply Filters"),
            //           style: ElevatedButton.styleFrom(
            //             padding: EdgeInsets.symmetric(vertical: 16),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 16),
            //       Expanded(
            //         child: OutlinedButton(
            //           onPressed: () {},
            //           child: Text("Clear")

            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _companyDropDown({
    required void Function(String?)? onChanged,
    required List<String> items,
    required String? value, // ADD THIS
  }) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: value, //// ✅ This line ensures reactive UI update
        items: items
            .map(
              (company) => DropdownMenuItem(
                value: company,
                child: Text(
                  company,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            )
            .toList(),
        hint: Text(
          'Select Company',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
        icon: Icon(Icons.keyboard_arrow_down, size: 20),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void showbtm() {
    Get.bottomSheet(
      Container(
        height: HelperFunctions.screenHeight() * 0.9,
        width: HelperFunctions.screenWidth(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                return _companyDropDown(
                  onChanged: (p0) async {
                    controller.selectedCategory.value = p0!;
                    await controller.fetchProducts();
                  },

                  items: controller.categories,

                  value: controller.selectedCategory.value,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
