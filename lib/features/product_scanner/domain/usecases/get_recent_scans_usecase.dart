import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetRecentScansUseCase {
  final ProductRepository _repository;

  GetRecentScansUseCase(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getRecentScans();
  }
}

class SaveScanUseCase {
  final ProductRepository _repository;

  SaveScanUseCase(this._repository);

  Future<void> call(Product product) async {
    return await _repository.saveScan(product);
  }
}
