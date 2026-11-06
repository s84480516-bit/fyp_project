import 'package:flutter/material.dart';
import '../../domain/entities/alternative_product.dart';
import '../../domain/usecases/get_alternatives_usecase.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';

class RecommendationsProvider extends ChangeNotifier {
  final GetAlternativesUseCase _getAlternativesUseCase;

  RecommendationsProvider(this._getAlternativesUseCase);

  Product? _originalProduct;
  Product? get originalProduct => _originalProduct;

  List<AlternativeProduct> _alternatives = [];
  List<AlternativeProduct> get alternatives => _alternatives;

  AlternativeProduct? _selectedAlternativeForComparison;
  AlternativeProduct? get selectedAlternativeForComparison => _selectedAlternativeForComparison;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadAlternatives(Product product) async {
    _originalProduct = product;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _alternatives = await _getAlternativesUseCase(product);
    } catch (e) {
      _errorMessage = 'Could not load alternatives: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectForComparison(AlternativeProduct alternative) {
    _selectedAlternativeForComparison = alternative;
    notifyListeners();
  }
}
