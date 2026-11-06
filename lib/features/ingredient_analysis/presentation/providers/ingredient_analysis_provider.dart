import 'package:flutter/material.dart';
import '../../domain/entities/ingredient_safety_report.dart';
import '../../domain/usecases/analyze_ingredients_usecase.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';

class IngredientAnalysisProvider extends ChangeNotifier {
  final AnalyzeIngredientsUseCase _analyzeIngredientsUseCase;

  IngredientAnalysisProvider(this._analyzeIngredientsUseCase);

  Product? _currentProduct;
  Product? get currentProduct => _currentProduct;

  IngredientSafetyReport? _report;
  IngredientSafetyReport? get report => _report;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Set<int> _expandedIndices = {};
  Set<int> get expandedIndices => _expandedIndices;

  Future<void> analyzeProduct(Product product) async {
    _currentProduct = product;
    _isLoading = true;
    _errorMessage = null;
    _expandedIndices.clear();
    notifyListeners();

    try {
      _report = await _analyzeIngredientsUseCase(product);
    } catch (e) {
      _errorMessage = 'Failed to analyze ingredients: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleExpand(int index) {
    if (_expandedIndices.contains(index)) {
      _expandedIndices.remove(index);
    } else {
      _expandedIndices.add(index);
    }
    notifyListeners();
  }

  bool isExpanded(int index) => _expandedIndices.contains(index);
}
