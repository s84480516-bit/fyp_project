import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Product> getProductByBarcode(String barcode) async {
    // Check local cache first
    final cached = await _localDataSource.getCachedProduct(barcode);
    if (cached != null) {
      return cached;
    }

    // Fetch from Open Food Facts API
    final remoteProduct = await _remoteDataSource.getProductByBarcode(barcode);
    await _localDataSource.saveScan(remoteProduct);
    return remoteProduct;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    return await _remoteDataSource.searchProducts(query);
  }

  @override
  Future<List<Product>> getRecentScans() async {
    return await _localDataSource.getRecentScans();
  }

  @override
  Future<void> saveScan(Product product) async {
    await _localDataSource.saveScan(ProductModel.fromEntity(product));
  }
}
