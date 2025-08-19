class AddToCartModel {
  final bool success;
  final String message;
  final CartData? data;

  AddToCartModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CartData {
  final String id;
  final String user;
  final String product;
  final int quantity;
  final String image;
  final double price;
  final DateTime addedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CartData({
    required this.id,
    required this.user,
    required this.product,
    required this.quantity,
    required this.image,
    required this.price,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      product: json['product'] ?? '',
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'product': product,
      'quantity': quantity,
      'image': image,
      'price': price,
      'addedAt': addedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
