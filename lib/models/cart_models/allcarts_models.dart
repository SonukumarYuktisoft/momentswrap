class AllCartsModels {
  final bool success;
  final List<CartItem> data;

  AllCartsModels({required this.success, required this.data});

  factory AllCartsModels.fromJson(Map<String, dynamic> json) {
    return AllCartsModels(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({required this.id, required this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'product': product.toJson(), 'quantity': quantity};
  }
}

class Product {
  final String id;
  final String name;
  final String category;
  final String shortDescription;
  final String longDescription;
  final double price; // Changed from int to double
  final int stock;
  final List<String> images;
  final String material;
  final List<String> saleFor;
  final String warranty;
  final String usageInstructions;
  final List<dynamic> offers;
  final List<dynamic> technicalSpecifications;
  final String shop;
  final double averageRating;
  final bool isActive;
  final String productId;
  final List<dynamic> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.stock,
    required this.images,
    required this.material,
    required this.saleFor,
    required this.warranty,
    required this.usageInstructions,
    required this.offers,
    required this.technicalSpecifications,
    required this.shop,
    required this.averageRating,
    required this.isActive,
    required this.productId,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      longDescription: json['longDescription'] ?? '',
      price:
          (json['price'] as num?)?.toDouble() ??
          0.0, // Fixed: Handle both int and double
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      material: json['material'] ?? '',
      saleFor: List<String>.from(json['saleFor'] ?? []),
      warranty: json['warranty'] ?? '',
      usageInstructions: json['usageInstructions'] ?? '',
      offers: List<dynamic>.from(json['offers'] ?? []),
      technicalSpecifications: List<dynamic>.from(
        json['technicalSpecifications'] ?? [],
      ),
      shop: json['shop'] ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
      productId: json['productId'] ?? '',
      reviews: List<dynamic>.from(json['reviews'] ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'category': category,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'price': price,
      'stock': stock,
      'images': images,
      'material': material,
      'saleFor': saleFor,
      'warranty': warranty,
      'usageInstructions': usageInstructions,
      'offers': offers,
      'technicalSpecifications': technicalSpecifications,
      'shop': shop,
      'averageRating': averageRating,
      'isActive': isActive,
      'productId': productId,
      'reviews': reviews,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
