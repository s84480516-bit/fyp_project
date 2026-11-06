import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByBarcodeUseCase {
  final ProductRepository _repository;

  GetProductByBarcodeUseCase(this._repository);

  Future<Product> call(String barcode) async {
    return await _repository.getProductByBarcode(barcode);
  }
}
