import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../entities/ingredient_safety_report.dart';
import '../repositories/ingredient_analysis_repository.dart';

class AnalyzeIngredientsUseCase {
  final IngredientAnalysisRepository _repository;

  AnalyzeIngredientsUseCase(this._repository);

  Future<IngredientSafetyReport> call(Product product) async {
    return await _repository.analyzeProductIngredients(product);
  }
}
