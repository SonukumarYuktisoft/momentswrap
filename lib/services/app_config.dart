class AppConfig {
  static const String baseUrl = 'https://moment-wrap-backend.vercel.app';
  // static const String listAllProducts = '$baseUrl/api/customer/list-all-products';

  // Auth APIs Endpoints
  String get registerUser => '$baseUrl /api/customer/register-customer';
  String get loginUser => '$baseUrl/api/customer/login-customer';
  String get logoutUser => '$baseUrl/api/customer/logout-customer';
  String get changePassword => '$baseUrl/api/customer/change-password';

  // Profile APIs Endpoints

  String get getUserProfile => '$baseUrl/api/customer/get-customer-profile';
  String get updateUserProfile =>
      '$baseUrl/api/customer/update-customer-profile';
  String get deleteUserProfile =>
      '$baseUrl/api/customer/delete-customer-profile';

  //Products APIs Endpoints
  //// List All Products
  String get getListAllProducts => '$baseUrl/api/customer/list-all-products';
  String get getProductDetailsById =>
      '$baseUrl/api/customer/product-details-by-id';
  String get listProductsByCategory =>
      '$baseUrl/api/customer/list-products-by-category';
  String get getListProductsByCategory =>
      "$baseUrl/api/customer/list-products-by-category/";
  String get getFilterProducts => "$baseUrl/api/customer/filter-products";
  String get getProductDetails =>
      "$baseUrl/api/customer/get-product-details"; // Base URL, append /:id

  // Helper method for product details by ID
  // String  getProductDetailsById(String productId) => "$getProductDetails/$productId";

  // Cart APIs Endpoints
  String get addToCart => '$baseUrl/api/customer/add-to-cart';
  String get getCartItems => '$baseUrl/api/customer/get-cart-items';
  String get updateCartItem => '$baseUrl/api/customer/update-cart-item';
  String get removeCartItem => '$baseUrl/api/customer/remove-cart-item';
  String get clearCart => '$baseUrl/api/customer/clear-cart';

  // Order APIs Endpoints
  String get placeOrder => '$baseUrl/api/customer/place-order';
  String get getOrderHistory => '$baseUrl/api/customer/get-order-history';
  String get getOrderDetails => '$baseUrl/api/customer/get-order-details';
  String get cancelOrder => '$baseUrl/api/customer/cancel-order';
  String get returnOrder => '$baseUrl/api/customer/return-order';
  String get getAllOrders => '$baseUrl/api/customer/get-all-orders';
  String get getOrderById => '$baseUrl/api/customer/get-order-by-id';
  String get updateOrderStatus => '$baseUrl/api/customer/update-order-status';

  // Review APIs Endpoints
  String get addReview => '$baseUrl/api/customer/add-review';
  String get getProductReviews => '$baseUrl/api/customer/get-product-reviews';
  String get getAllReviews => '$baseUrl/api/customer/get-all-reviews';
  String get deleteReview => '$baseUrl/api/customer/delete-review';
  String get updateReview => '$baseUrl/api/customer/update-review';
  String get getReviewById => '$baseUrl/api/customer/get-review-by-id';
}
