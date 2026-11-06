import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../entities/ingredient_safety_report.dart';

abstract class IngredientAnalysisRepository {
  Future<IngredientSafetyReport> analyzeProductIngredients(Product product);
}
