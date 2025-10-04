import 'config.dart';

class BASEURL {
  static String get basePath => ApiConfig.currentBasePath;

  static String get apiRegister => '${basePath}register_api.php';
  static String get apiLogin => '${basePath}login_api.php';
  static String get categoryWithProduct =>
      '${basePath}get_product_with_category.php';
  static String get getProduct => '${basePath}get_products.php';
  static String get addToCart => '${basePath}add_to_cart.php';

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
