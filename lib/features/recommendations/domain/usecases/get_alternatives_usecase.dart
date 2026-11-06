import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../entities/alternative_product.dart';
import '../repositories/recommendations_repository.dart';

class GetAlternativesUseCase {
  final RecommendationsRepository _repository;

  GetAlternativesUseCase(this._repository);

  Future<List<AlternativeProduct>> call(Product originalProduct) async {
    return await _repository.getAlternativesForProduct(originalProduct);
  }
}
