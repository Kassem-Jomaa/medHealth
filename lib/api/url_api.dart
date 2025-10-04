import 'config.dart';

class BASEURL {
  static const String basePath = ApiConfig.currentBasePath;

  static const String apiRegister = '${basePath}register_api.php';
  static const String apiLogin = '${basePath}login_api.php';
  static const String categoryWithProduct =
      '${basePath}get_product_with_category.php';
  static const String getProduct = '${basePath}get_products.php';
  static const String addToCart = '${basePath}add_to_cart.php';

  // Dynamic endpoint for getting cart products by user ID
  static String getProductCart(String userID) {
    return '${basePath}get_cart.php?userID=$userID';
  }

  static String getTotalCart(String userID) {
    return '${basePath}total_cart.php?userID=$userID';
  }

  static String updateQuantityCart(String userID) {
    return '${basePath}update_quantity.php?userID=$userID';
  }
}
