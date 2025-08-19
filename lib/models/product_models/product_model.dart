class ProductModel {
  bool? success;
  List<Product>? data; // 👈 API me "data" hai, not "products"

  ProductModel({this.success, this.data});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Product {
  String? id;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? material;
  List<String>? isSafeFor;
  String? usageInstructions;
  List<TechnicalSpecification>? technicalSpecifications;
  List<String>? certifications;
  String? warranty;
  int? price;
  int? stock;
  String? category;
  List<String>? tags;
  List<String>? image;
  List<String>? additionalImages;
  String? shop;
  List<dynamic>? offers;
  String? createdAt;
  String? updatedAt;
  int? v;

  Product({
    this.id,
    this.name,
    this.shortDescription,
    this.longDescription,
    this.material,
    this.isSafeFor,
    this.usageInstructions,
    this.technicalSpecifications,
    this.certifications,
    this.warranty,
    this.price,
    this.stock,
    this.category,
    this.tags,
    this.image,
    this.additionalImages,
    this.shop,
    this.offers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      shortDescription: json['shortDescription'] as String?,
      longDescription: json['longDescription'] as String?,
      material: json['material'] as String?,
      isSafeFor: (json['isSafeFor'] as List<dynamic>?)?.cast<String>(),
      usageInstructions: json['usageInstructions'] as String?,
      technicalSpecifications: (json['technicalSpecifications'] as List<dynamic>?)
          ?.map((e) => TechnicalSpecification.fromJson(e))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)?.cast<String>(),
      warranty: json['warranty'] as String?,
      price: json['price'] as int?,
      stock: json['stock'] as int?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      image: (json['image'] as List<dynamic>?)?.cast<String>(),
      additionalImages: (json['additionalImages'] as List<dynamic>?)?.cast<String>(),
      shop: json['shop'] as String?,
      offers: json['offers'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }
}

class TechnicalSpecification {
  String? id;
  String? weight;
  String? dimensions;
  String? color;

  TechnicalSpecification({this.id, this.weight, this.dimensions, this.color});

  factory TechnicalSpecification.fromJson(Map<String, dynamic> json) {
    return TechnicalSpecification(
      id: json['_id'] as String?,
      weight: json['weight'] as String?,
      dimensions: json['dimensions'] as String?,
      color: json['color'] as String?,
    );
  }
}
