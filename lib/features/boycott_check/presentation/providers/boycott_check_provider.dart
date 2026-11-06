import 'package:flutter/material.dart';
import '../../domain/entities/boycott_record.dart';
import '../../domain/usecases/check_boycott_status_usecase.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/domain/entities/alternative_product.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/domain/usecases/get_alternatives_usecase.dart';

class BoycottCheckProvider extends ChangeNotifier {
  final CheckBoycottStatusUseCase _checkBoycottStatusUseCase;
  final GetAlternativesUseCase _getAlternativesUseCase;

  BoycottCheckProvider({
    required CheckBoycottStatusUseCase checkBoycottStatusUseCase,
    required GetAlternativesUseCase getAlternativesUseCase,
  })  : _checkBoycottStatusUseCase = checkBoycottStatusUseCase,
        _getAlternativesUseCase = getAlternativesUseCase;

  Product? _currentProduct;
  Product? get currentProduct => _currentProduct;

  BoycottRecord? _record;
  BoycottRecord? get record => _record;

  List<AlternativeProduct> _safeAlternatives = [];
  List<AlternativeProduct> get safeAlternatives => _safeAlternatives;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> checkBrand(Product product) async {
    _currentProduct = product;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _record = await _checkBoycottStatusUseCase(product.brand);
      _safeAlternatives = await _getAlternativesUseCase(product);
    } catch (e) {
      _errorMessage = 'Could not verify brand boycott registry: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
