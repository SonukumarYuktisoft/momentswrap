class AllCartsModels {
  final bool success;
  final List<CartItem> data;

  AllCartsModels({
    required this.success,
    required this.data,
  });

  factory AllCartsModels.fromJson(Map<String, dynamic> json) {
    return AllCartsModels(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
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
  final User? user;
  final Product? product;
  final int quantity;
  final String image;
  final double price;
  final DateTime addedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CartItem({
    required this.id,
    this.user,
    this.product,
    required this.quantity,
    required this.image,
    required this.price,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'product': product?.toJson(),
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

class User {
  final Address address;
  final SocialMedia socialMedia;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String helplineNumber;
  final String profileImage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  User({
    required this.address,
    required this.socialMedia,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    required this.helplineNumber,
    required this.profileImage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      address: Address.fromJson(json['address'] ?? {}),
      socialMedia: SocialMedia.fromJson(json['socialMedia'] ?? {}),
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      helplineNumber: json['helplineNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      'socialMedia': socialMedia.toJson(),
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'helplineNumber': helplineNumber,
      'profileImage': profileImage,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }
}

class SocialMedia {
  final String facebook;
  final String twitter;
  final String instagram;
  final String linkedin;

  SocialMedia({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.linkedin,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      facebook: json['facebook'] ?? '',
      twitter: json['twitter'] ?? '',
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'linkedin': linkedin,
    };
  }
}

class Product {
  final List<dynamic> saleFor;
  final String id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String material;
  final List<String> isSafeFor;
  final String usageInstructions;
  final List<TechnicalSpecification> technicalSpecifications;
  final List<String> certifications;
  final String warranty;
  final int price;
  final int stock;
  final String category;
  final List<String> tags;
  final List<String> image;
  final List<String> additionalImages;
  final String shop;
  final List<dynamic> offers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Product({
    required this.saleFor,
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.material,
    required this.isSafeFor,
    required this.usageInstructions,
    required this.technicalSpecifications,
    required this.certifications,
    required this.warranty,
    required this.price,
    required this.stock,
    required this.category,
    required this.tags,
    required this.image,
    required this.additionalImages,
    required this.shop,
    required this.offers,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      saleFor: List<dynamic>.from(json['saleFor'] ?? []),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      longDescription: json['longDescription'] ?? '',
      material: json['material'] ?? '',
      isSafeFor: List<String>.from(json['isSafeFor'] ?? []),
      usageInstructions: json['usageInstructions'] ?? '',
      technicalSpecifications: (json['technicalSpecifications'] as List<dynamic>?)
          ?.map((spec) => TechnicalSpecification.fromJson(spec))
          .toList() ??
          [],
      certifications: List<String>.from(json['certifications'] ?? []),
      warranty: json['warranty'] ?? '',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      image: List<String>.from(json['image'] ?? []),
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
      shop: json['shop'] ?? '',
      offers: List<dynamic>.from(json['offers'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saleFor': saleFor,
      '_id': id,
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'material': material,
      'isSafeFor': isSafeFor,
      'usageInstructions': usageInstructions,
      'technicalSpecifications': technicalSpecifications.map((spec) => spec.toJson()).toList(),
      'certifications': certifications,
      'warranty': warranty,
      'price': price,
      'stock': stock,
      'category': category,
      'tags': tags,
      'image': image,
      'additionalImages': additionalImages,
      'shop': shop,
      'offers': offers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class TechnicalSpecification {
  final String id;
  final String? dimensions;
  final String? color;
  final String? weight;

  TechnicalSpecification({
    required this.id,
    this.dimensions,
    this.color,
    this.weight,
  });

  factory TechnicalSpecification.fromJson(Map<String, dynamic> json) {
    return TechnicalSpecification(
      id: json['_id'] ?? '',
      dimensions: json['dimensions'],
      color: json['color'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dimensions': dimensions,
      'color': color,
      'weight': weight,
    };
  }
}