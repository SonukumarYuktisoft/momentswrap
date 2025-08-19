class CartItem {
  final String id;
  final String user;
  final String product;
  final int quantity;
  final String image;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    required this.id,
    required this.user,
    required this.product,
    required this.quantity,
    required this.image,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      user: json['user'],
      product: json['product'],
      quantity: json['quantity'],
      image: json['image'],
      price: json['price'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}