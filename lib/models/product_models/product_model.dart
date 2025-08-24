class ProductResponse {
  final List<ProductModel> data;

  ProductResponse({required this.data});

  factory ProductResponse.fromJson(List<dynamic> json) {
    return ProductResponse(
      data: json.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String shortDescription;
  final String longDescription;
  final int price;
  final List<String> images;
  final int stock;
  final double averageRating;
  final String material;
  final List<String> saleFor;
  final String warranty;
  final String usageInstructions;
  final List<Offer> offers;
  final List<TechnicalSpecification> technicalSpecifications;
  final String shop;
  final List<Review> reviews;
  final bool isActive;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.images,
    required this.stock,
    required this.averageRating,
    required this.material,
    required this.saleFor,
    required this.warranty,
    required this.usageInstructions,
    required this.offers,
    required this.technicalSpecifications,
    required this.shop,
    required this.reviews,
    required this.isActive,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      longDescription: json['longDescription'] ?? '',
      price: json['price'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      material: json['material'] ?? '',
      saleFor: List<String>.from(json['saleFor'] ?? []),
      warranty: json['warranty'] ?? '',
      usageInstructions: json['usageInstructions'] ?? '',
      offers: List<Offer>.from(
          (json['offers'] ?? []).map((x) => Offer.fromJson(x))),
      technicalSpecifications: List<TechnicalSpecification>.from(
          (json['technicalSpecifications'] ?? [])
              .map((x) => TechnicalSpecification.fromJson(x))),
      shop: json['shop'] ?? '',
      reviews: List<Review>.from(
          (json['reviews'] ?? []).map((x) => Review.fromJson(x))),
      isActive: json['isActive'] ?? false,
      productId: json['productId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? '2025-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse(json['updatedAt'] ?? '2025-01-01T00:00:00.000Z'),
    );
  }
}

class Offer {
  final String id;
  final String offerTitle;
  final String offerDescription;
  final int discountPercentage;
  final DateTime validTill;

  Offer({
    required this.id,
    required this.offerTitle,
    required this.offerDescription,
    required this.discountPercentage,
    required this.validTill,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'] ?? '',
      offerTitle: json['offerTitle'] ?? '',
      offerDescription: json['offerDescription'] ?? '',
      discountPercentage: json['discountPercentage'] ?? 0,
      validTill: DateTime.parse(json['validTill'] ?? '2025-01-01T00:00:00.000Z'),
    );
  }
}

class TechnicalSpecification {
  final String id;
  final String specName;
  final String specValue;

  TechnicalSpecification({
    required this.id,
    required this.specName,
    required this.specValue,
  });

  factory TechnicalSpecification.fromJson(Map<String, dynamic> json) {
    return TechnicalSpecification(
      id: json['_id'] ?? '',
      specName: json['specName'] ?? '',
      specValue: json['specValue'] ?? '',
    );
  }
}

class Review {
  final String id;
  final String customer;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.customer,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      customer: json['customer'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? '2025-01-01T00:00:00.000Z'),
    );
  }
}