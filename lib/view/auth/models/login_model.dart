class LoginModel {
  final String message;
  final String token;
  final Customer customer;

  LoginModel({
    required this.message,
    required this.token,
    required this.customer,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "token": token,
      "customer": customer.toJson(),
    };
  }
}

class Customer {
  final SocialMedia socialMedia;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String profileImage;
  final List<dynamic> addresses;
  final bool isActive;
  final bool isVerified;
  final String role;
  final List<dynamic> wishlist;
  final List<dynamic> orderHistory;
  final List<Cart> cart;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String lastLogin;

  Customer({
    required this.socialMedia,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.profileImage,
    required this.addresses,
    required this.isActive,
    required this.isVerified,
    required this.role,
    required this.wishlist,
    required this.orderHistory,
    required this.cart,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastLogin,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      socialMedia: SocialMedia.fromJson(json['socialMedia'] ?? {}),
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      profileImage: json['profileImage'] ?? '',
      addresses: List<dynamic>.from(json['addresses'] ?? []),
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      role: json['role'] ?? '',
      wishlist: List<dynamic>.from(json['wishlist'] ?? []),
      orderHistory: List<dynamic>.from(json['orderHistory'] ?? []),
      cart: (json['cart'] as List<dynamic>? ?? [])
          .map((e) => Cart.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      lastLogin: json['lastLogin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "socialMedia": socialMedia.toJson(),
      "_id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
      "profileImage": profileImage,
      "addresses": addresses,
      "isActive": isActive,
      "isVerified": isVerified,
      "role": role,
      "wishlist": wishlist,
      "orderHistory": orderHistory,
      "cart": cart.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "lastLogin": lastLogin,
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
      "facebook": facebook,
      "twitter": twitter,
      "instagram": instagram,
      "linkedin": linkedin,
    };
  }
}

class Cart {
  final String product;
  final int quantity;
  final String id;

  Cart({
    required this.product,
    required this.quantity,
    required this.id,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      product: json['product'] ?? '',
      quantity: json['quantity'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product": product,
      "quantity": quantity,
      "_id": id,
    };
  }
}
