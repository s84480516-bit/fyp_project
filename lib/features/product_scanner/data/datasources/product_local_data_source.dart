import 'dart:convert';
import '../../../../core/services/local storage/local_storage_service.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getRecentScans();
  Future<void> saveScan(ProductModel product);
  Future<ProductModel?> getCachedProduct(String barcode);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final LocalStorageService _storageService;
  static const String _recentScansKey = 'scaneth_recent_scans';
  static const String _productCachePrefix = 'scaneth_prod_';

  ProductLocalDataSourceImpl(this._storageService);

  @override
  Future<List<ProductModel>> getRecentScans() async {
    try {
      final data = await _storageService.readValue(_recentScansKey);
      if (data != null && data is String) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          return decoded
              .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
        }
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> saveScan(ProductModel product) async {
    try {
      final scans = await getRecentScans();
      scans.removeWhere((p) => p.barcode == product.barcode);
      scans.insert(0, product);
      if (scans.length > 20) scans.removeLast();

      await _storageService.setValue(
        _recentScansKey,
        jsonEncode(scans.map((p) => p.toJson()).toList()),
      );

      await _storageService.setValue(
        '$_productCachePrefix${product.barcode}',
        jsonEncode(product.toJson()),
      );
    } catch (_) {}
  }

  @override
  Future<ProductModel?> getCachedProduct(String barcode) async {
    try {
      final data = await _storageService.readValue('$_productCachePrefix$barcode');
      if (data != null && data is String) {
        final decoded = jsonDecode(data);
        return ProductModel.fromJson(Map<String, dynamic>.from(decoded as Map));
      }
    } catch (_) {}
    return null;
  }
}
