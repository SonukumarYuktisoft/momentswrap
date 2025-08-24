class OrderModel {
  final String id;
  final String customer;
  final List<OrderProduct> products;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  
  // Optional fields for future extensions
  final ShippingAddress? shippingAddress;
  final String? trackingNumber;
  final String? estimatedDelivery;
  final String? notes;

  OrderModel({
    required this.id,
    required this.customer,
    required this.products,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
    this.v = 0,
    this.shippingAddress,
    this.trackingNumber,
    this.estimatedDelivery,
    this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id']?.toString() ?? '',
      customer: json['customer']?.toString() ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((product) => OrderProduct.fromJson(product as Map<String, dynamic>))
          .toList() ?? [],
      totalAmount: _parseDouble(json['totalAmount']),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      orderStatus: json['orderStatus']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      v: _parseInt(json['__v']),
      shippingAddress: json['shippingAddress'] != null 
          ? ShippingAddress.fromJson(json['shippingAddress'] as Map<String, dynamic>)
          : null,
      trackingNumber: json['trackingNumber']?.toString(),
      estimatedDelivery: json['estimatedDelivery']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customer': customer,
      'products': products.map((product) => product.toJson()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      if (shippingAddress != null) 'shippingAddress': shippingAddress!.toJson(),
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (estimatedDelivery != null) 'estimatedDelivery': estimatedDelivery,
      if (notes != null) 'notes': notes,
    };
  }

  // copyWith method for immutable updates
  OrderModel copyWith({
    String? id,
    String? customer,
    List<OrderProduct>? products,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? orderStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    ShippingAddress? shippingAddress,
    String? trackingNumber,
    String? estimatedDelivery,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      products: products ?? this.products,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      notes: notes ?? this.notes,
    );
  }

  // Helper methods
  String get formattedOrderId => id.length > 8 ? id.substring(id.length - 8) : id;
  String get statusDisplayName => orderStatus.toUpperCase();
  bool get isPending => orderStatus.toLowerCase() == 'pending';
  bool get isCompleted => orderStatus.toLowerCase() == 'completed';
  bool get isCancelled => orderStatus.toLowerCase() == 'cancelled';
  
  int get totalQuantity => products.fold(0, (sum, product) => sum + product.quantity);
  
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

class OrderProduct {
  final ProductInfo product;
  final String name;
  final double price;
  final int quantity;
  final String id;

  OrderProduct({
    required this.product,
    required this.name,
    required this.price,
    required this.quantity,
    required this.id,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      product: ProductInfo.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
      name: json['name']?.toString() ?? '',
      price: _parseDouble(json['price']),
      quantity: _parseInt(json['quantity']),
      id: json['_id']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'name': name,
      'price': price,
      'quantity': quantity,
      '_id': id,
    };
  }

  // Helper methods
  double get totalPrice => price * quantity;
  String get displayName => name.isNotEmpty ? name : product.name;
  String? get firstImage => product.images.isNotEmpty ? product.images.first : null;
}

class ProductInfo {
  final String id;
  final String name;
  final String category;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int stock;
  final List<String> images;
  final String material;
  final List<String> saleFor;
  final String warranty;
  final String usageInstructions;
  final List<Offer> offers;
  final List<TechnicalSpecification> technicalSpecifications;
  final String shop;
  final double averageRating;
  final List<Review> reviews;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String productId;
  final int v;

  ProductInfo({
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
    required this.reviews,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    this.v = 0,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ?? '',
      longDescription: json['longDescription']?.toString() ?? '',
      price: _parseDouble(json['price']),
      stock: _parseInt(json['stock']),
      images: _parseStringList(json['images']),
      material: json['material']?.toString() ?? '',
      saleFor: _parseStringList(json['saleFor']),
      warranty: json['warranty']?.toString() ?? '',
      usageInstructions: json['usageInstructions']?.toString() ?? '',
      offers: _parseOffers(json['offers']),
      technicalSpecifications: _parseTechnicalSpecs(json['technicalSpecifications']),
      shop: json['shop']?.toString() ?? '',
      averageRating: _parseDouble(json['averageRating']),
      reviews: _parseReviews(json['reviews']),
      isActive: json['isActive'] == true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      productId: json['productId']?.toString() ?? '',
      v: _parseInt(json['__v']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static List<Offer> _parseOffers(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((offer) {
      try {
        return Offer.fromJson(offer as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing offer: $e');
        return null;
      }
    }).where((offer) => offer != null).cast<Offer>().toList();
  }

  static List<TechnicalSpecification> _parseTechnicalSpecs(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((spec) {
      try {
        return TechnicalSpecification.fromJson(spec as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing technical specification: $e');
        return null;
      }
    }).where((spec) => spec != null).cast<TechnicalSpecification>().toList();
  }

  static List<Review> _parseReviews(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map((review) {
      try {
        return Review.fromJson(review as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing review: $e');
        return null;
      }
    }).where((review) => review != null).cast<Review>().toList();
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
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'technicalSpecifications': technicalSpecifications.map((spec) => spec.toJson()).toList(),
      'shop': shop,
      'averageRating': averageRating,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'productId': productId,
      '__v': v,
    };
  }
}

class Offer {
  final String offerTitle;
  final String offerDescription;
  final int discountPercentage;
  final DateTime validTill;
  final String id;

  Offer({
    required this.offerTitle,
    required this.offerDescription,
    required this.discountPercentage,
    required this.validTill,
    required this.id,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerTitle: json['offerTitle']?.toString() ?? '',
      offerDescription: json['offerDescription']?.toString() ?? '',
      discountPercentage: _parseInt(json['discountPercentage']),
      validTill: _parseDateTime(json['validTill']),
      id: json['_id']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'offerTitle': offerTitle,
      'offerDescription': offerDescription,
      'discountPercentage': discountPercentage,
      'validTill': validTill.toIso8601String(),
      '_id': id,
    };
  }

  bool get isValid => DateTime.now().isBefore(validTill);
  double calculateDiscount(double originalPrice) => originalPrice * (discountPercentage / 100);
  double calculateDiscountedPrice(double originalPrice) => originalPrice - calculateDiscount(originalPrice);
}

class TechnicalSpecification {
  final String specName;
  final String specValue;
  final String id;

  TechnicalSpecification({
    required this.specName,
    required this.specValue,
    required this.id,
  });

  factory TechnicalSpecification.fromJson(Map<String, dynamic> json) {
    return TechnicalSpecification(
      specName: json['specName']?.toString() ?? '',
      specValue: json['specValue']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specName': specName,
      'specValue': specValue,
      '_id': id,
    };
  }
}

class Review {
  final String customer;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String id;

  Review({
    required this.customer,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      customer: json['customer']?.toString() ?? '',
      rating: _parseInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      id: json['_id']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      '_id': id,
    };
  }
}

class ShippingAddress {
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;

  ShippingAddress({
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      addressLine1: json['addressLine1']?.toString() ?? '',
      addressLine2: json['addressLine2']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
    };
  }

  String get formattedAddress {
    List<String> addressParts = [];
    if (addressLine1.isNotEmpty) addressParts.add(addressLine1);
    if (addressLine2.isNotEmpty) addressParts.add(addressLine2);
    if (city.isNotEmpty) addressParts.add(city);
    if (state.isNotEmpty) addressParts.add(state);
    if (pincode.isNotEmpty) addressParts.add(pincode);
    if (country.isNotEmpty) addressParts.add(country);
    return addressParts.join(', ');
  }
}