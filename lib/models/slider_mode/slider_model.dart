// models/slider_model.dart
class SliderModel {
  final String id;
  final String name;
  final String shortDescription;
  final double price;
  final double? offerPrice;
  final List<String> images;
  final DateTime createdAt;

  SliderModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.price,
    this.offerPrice,
    required this.images,
    required this.createdAt,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      offerPrice: json['offerPrice']?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first : '';
  bool get hasOffer => offerPrice != null && offerPrice! < price;
  double get displayPrice => offerPrice ?? price;
  
  double? get discountPercentage {
    if (hasOffer) {
      return ((price - offerPrice!) / price * 100);
    }
    return null;
  }
}

// models/slider_response_model.dart
class SliderResponseModel {
  final bool success;
  final int count;
  final List<SliderModel> sliders;

  SliderResponseModel({
    required this.success,
    required this.count,
    required this.sliders,
  });

  factory SliderResponseModel.fromJson(Map<String, dynamic> json) {
    return SliderResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      sliders: (json['sliders'] as List<dynamic>?)
          ?.map((slider) => SliderModel.fromJson(slider))
          .toList() ?? [],
    );
  }
}