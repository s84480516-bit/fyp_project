import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../entities/alternative_product.dart';

abstract class RecommendationsRepository {
  Future<List<AlternativeProduct>> getAlternativesForProduct(Product originalProduct);
}
