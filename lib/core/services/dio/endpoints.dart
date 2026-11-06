class Endpoints {
  // Base URLs - Open Food Facts API
  static const String baseURL = "https://world.openfoodfacts.org";

  // Product endpoints
  static String productByBarcode(String barcode) => "/api/v2/product/$barcode.json";
  static const String searchProducts = "/cgi/search.pl";

  // Auth endpoints
  static const String signInUrl = '/users/auth/signin';
}
