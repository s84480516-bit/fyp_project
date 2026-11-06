import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProductByBarcode(String barcode);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getRecentScans();
  Future<void> saveScan(Product product);
}
