import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/view/home_screen/product_card.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/controllers/cart_controller/cart_controller.dart';

class AllProductsPage extends StatefulWidget {
  final String title;
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final String? subtitle;
  final IconData? titleIcon;

  const AllProductsPage({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    this.subtitle,
    this.titleIcon,
  });

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final CartController cartController = Get.put(CartController());

  // Filter and sort options
  String selectedSortBy = 'name'; // name, price_low, price_high, rating
  bool showInStockOnly = false;
  RangeValues priceRange = RangeValues(0, 10000);
  double minPrice = 0;
  double maxPrice = 10000;

  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _calculatePriceRange();
    _applyFiltersAndSort();
  }

  void _calculatePriceRange() {
    if (widget.products.isEmpty) return;

    final prices = widget.products.map((p) => p.price).toList();
    minPrice = prices.reduce((a, b) => a < b ? a : b).toDouble();
    maxPrice = prices.reduce((a, b) => a > b ? a : b).toDouble();
    priceRange = RangeValues(minPrice, maxPrice);
  }

  void _applyFiltersAndSort() {
    List<ProductModel> filtered = List.from(widget.products);

    // Apply stock filter
    if (showInStockOnly) {
      filtered = filtered.where((product) => product.stock > 0).toList();
    }

    // Apply price range filter
    filtered = filtered.where((product) {
      return product.price >= priceRange.start &&
          product.price <= priceRange.end;
    }).toList();

    // Apply sorting
    switch (selectedSortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
    }

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            if (widget.titleIcon != null) ...[
              Icon(widget.titleIcon, color: Colors.black),
              SizedBox(width: 8),
            ],
            Text(widget.title, style: TextStyle(color: Colors.black)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Get.toNamed(AppRoutes.searchScreen);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Sort Section
          // _buildFilterSection(),

          // Results Count
          // _buildResultsHeader(),

          // Products Grid or Empty State
          Expanded(child: _buildProductsGrid()),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh functionality can be added here
        // _applyFiltersAndSort();
      },
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 280,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ModernProductCard(
            image: product.images.isNotEmpty ? product.images.first : '',
            title: product.name,
            subtitle: product.shortDescription,
            price: "₹${product.price}",
            // productId: product.productId,
            offers: product.offers,
            stock: product.stock,
            showAddToCart: false,
            // addToCart: () {
            //   AuthUtils.runIfLoggedIn(() async {
            //     await cartController.addToCart(
            //       productId: product.id,
            //       quantity: 1,
            //       image: product.images.isNotEmpty ? product.images.first : '',
            //       totalPrice: product.price.toDouble(),
            //     );
            //   });
            // },
            onTap: () => widget.onProductTap(product),
          );
        },
      ),
    );
  }
}
