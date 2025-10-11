class CustomerProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final bool isActive;
  final bool isVerified;
  final String customerId;
  final String? gender;
  final String? dateOfBirth;
  final List<String> wishlist;
  final List<String> orderHistory;
  final List<CartItem> cart;
  final SocialMedia socialMedia;
  final List<Address> addresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  CustomerProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage = '',
    this.isActive = true,
    this.isVerified = false,
    this.customerId = '',
    this.gender,
    this.dateOfBirth,
    this.wishlist = const [],
    this.orderHistory = const [],
    this.cart = const [],
    SocialMedia? socialMedia,
    this.addresses = const [],
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
  }) : socialMedia = socialMedia ?? SocialMedia();

  // Factory constructor to create CustomerProfile from JSON
  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'customer',
      profileImage: json['profileImage'] ?? '',
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      customerId: json['customerId'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      wishlist: List<String>.from(json['wishlist'] ?? []),
      orderHistory: List<String>.from(json['orderHistory'] ?? []),
      cart: (json['cart'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      socialMedia: json['socialMedia'] != null
          ? SocialMedia.fromJson(json['socialMedia'])
          : SocialMedia(),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((addr) => Address.fromJson(addr))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
      lastLogin: json['lastLogin'] != null 
          ? DateTime.tryParse(json['lastLogin']) 
          : null,
    );
  }

  // Method to convert CustomerProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'isActive': isActive,
      'isVerified': isVerified,
      'customerId': customerId,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'wishlist': wishlist,
      'orderHistory': orderHistory,
      'cart': cart.map((item) => item.toJson()).toList(),
      'socialMedia': socialMedia.toJson(),
      'addresses': addresses.map((addr) => addr.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Method to create a copy with updated fields
  CustomerProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    bool? isActive,
    bool? isVerified,
    String? customerId,
    String? gender,
    String? dateOfBirth,
    List<String>? wishlist,
    List<String>? orderHistory,
    List<CartItem>? cart,
    SocialMedia? socialMedia,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return CustomerProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      customerId: customerId ?? this.customerId,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      wishlist: wishlist ?? this.wishlist,
      orderHistory: orderHistory ?? this.orderHistory,
      cart: cart ?? this.cart,
      socialMedia: socialMedia ?? this.socialMedia,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  // Get full name
  String get fullName => '$firstName $lastName'.trim();

  @override
  String toString() {
    return 'CustomerProfile(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerProfile &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.role == role;
  }

  @override
  int get hashCode {
    return Object.hash(id, firstName, lastName, email, phone, role);
  }
}

// Supporting models
class CartItem {
  final String product;
  final int quantity;
  final String id;

  CartItem({
    required this.product,
    required this.quantity,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: json['product'] ?? '',
      quantity: json['quantity'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
      '_id': id,
    };
  }
}

class SocialMedia {
  final String facebook;
  final String twitter;
  final String instagram;
  final String linkedin;

  SocialMedia({
    this.facebook = '',
    this.twitter = '',
    this.instagram = '',
    this.linkedin = '',
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

class Address {
  final String id;
  final String type;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode; // Made nullable to handle missing postalCode
  final bool isDefault;

  Address({
    required this.id,
    this.type = '',
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      // Handle both zipCode and postalCode from API, with null safety
      zipCode: json['zipCode'] ?? json['postalCode'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': zipCode, // Send as postalCode to match API
      'isDefault': isDefault,
    };
  }

  // Helper method to check if address is complete
  bool get isComplete {
    return street?.isNotEmpty == true &&
           city?.isNotEmpty == true &&
           state?.isNotEmpty == true &&
           country?.isNotEmpty == true;
  }

  // Get formatted address string
  String get formattedAddress {
    final parts = <String>[];
    if (street?.isNotEmpty == true) parts.add(street!);
    if (city?.isNotEmpty == true) parts.add(city!);
    if (state?.isNotEmpty == true) parts.add(state!);
    if (zipCode?.isNotEmpty == true) parts.add(zipCode!);
    if (country?.isNotEmpty == true) parts.add(country!);
    return parts.join(', ');
  }
}

// API Response Models
class CustomerProfileResponse {
  final bool success;
  final CustomerProfile? data;
  final String? message;

  CustomerProfileResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory CustomerProfileResponse.fromJson(Map<String, dynamic> json) {
    // Check if response has success field, otherwise assume success if data exists
    bool isSuccess = false;
    CustomerProfile? profileData;
    String? message;

    if (json.containsKey('success')) {
      // Standard wrapped response
      isSuccess = json['success'] == true || json['success'] == 200;
      profileData = json['data'] != null ? CustomerProfile.fromJson(json['data']) : null;
      message = json['message'];
    } else if (json.containsKey('_id')) {
      // Direct profile data response (like your API)
      isSuccess = true;
      profileData = CustomerProfile.fromJson(json);
      message = 'Profile loaded successfully';
    }

    return CustomerProfileResponse(
      success: isSuccess,
      data: profileData,
      message: message,
    );
  }
}

class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String phone;
  final String? profileImage;
  final String? gender;
  final String? dateOfBirth;
  final List<Map<String, dynamic>>? addresses;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.addresses,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };

    if (profileImage != null && profileImage!.isNotEmpty) {
      data['profileImage'] = profileImage;
    }

    if (gender != null && gender!.isNotEmpty) {
      data['gender'] = gender;
    }

    if (dateOfBirth != null && dateOfBirth!.isNotEmpty) {
      data['dateOfBirth'] = dateOfBirth;
    }

    if (addresses != null && addresses!.isNotEmpty) {
      data['addresses'] = addresses;
    }

    return data;
  }
}