import 'package:flutter_test/flutter_test.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/data/models/product_model.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/repositories/product_repository.dart';
import 'package:cleanarchitecturetemplate/features/product_scanner/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/domain/entities/ingredient_item.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/data/datasources/ingredient_analysis_data_source.dart';
import 'package:cleanarchitecturetemplate/features/ingredient_analysis/data/repositories/ingredient_analysis_repository_impl.dart';
import 'package:cleanarchitecturetemplate/features/boycott_check/data/datasources/boycott_data_source.dart';
import 'package:cleanarchitecturetemplate/features/boycott_check/data/repositories/boycott_check_repository_impl.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/data/datasources/recommendations_data_source.dart';
import 'package:cleanarchitecturetemplate/features/recommendations/data/repositories/recommendations_repository_impl.dart';
import 'package:cleanarchitecturetemplate/core/services/firebase/firebase_service.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<Product> getProductByBarcode(String barcode) async {
    return Product(
      id: barcode,
      barcode: barcode,
      name: 'Oatly Barista Edition Oat Milk',
      brand: 'Oatly',
      imageUrl: 'https://images.openfoodfacts.org/oatly.jpg',
      ingredientsText: 'Water, Oats, Rapeseed oil, Salt',
      rawIngredients: const ['Water', 'Oats', 'Rapeseed oil', 'Salt'],
    );
  }

  @override
  Future<List<Product>> searchProducts(String query) async => [];

  @override
  Future<List<Product>> getRecentScans() async => [];

  @override
  Future<void> saveScan(Product product) async {}
}

void main() {
  group('ScanEth AI Product Scanner Tests', () {
    test('ProductModel parses Open Food Facts JSON correctly', () {
      final json = {
        'code': '7394376616030',
        'product_name': 'Oatly Barista Edition',
        'brands': 'Oatly',
        'image_url': 'https://example.com/image.jpg',
        'quantity': '1 L',
        'categories': 'Beverages, Plant-based foods',
        'ingredients_text': 'Water, Oats, Rapeseed oil',
        'ecoscore_grade': 'b',
        'nova_group': 3,
        'nutriscore_grade': 'b',
      };

      final model = ProductModel.fromJson(json);

      expect(model.barcode, '7394376616030');
      expect(model.name, 'Oatly Barista Edition');
      expect(model.brand, 'Oatly');
      expect(model.ecoScore, 'B');
      expect(model.novaGroup, 3);
      expect(model.isBoycotted, false);
    });

    test('GetProductByBarcodeUseCase retrieves product entity', () async {
      final repo = MockProductRepository();
      final useCase = GetProductByBarcodeUseCase(repo);

      final result = await useCase('7394376616030');

      expect(result.name, 'Oatly Barista Edition Oat Milk');
      expect(result.brand, 'Oatly');
      expect(result.barcode, '7394376616030');
    });
  });

  group('ScanEth AI Ingredient Safety Analysis Tests', () {
    test('Ingredient analysis accurately flags safe and attention components', () async {
      final firebaseService = FirebaseService();
      final dataSource = IngredientAnalysisDataSourceImpl(firebaseService);
      final repo = IngredientAnalysisRepositoryImpl(dataSource);

      const product = Product(
        id: 'test_product',
        barcode: '12345678',
        name: 'Barista Drink',
        brand: 'TestBrand',
        imageUrl: '',
        rawIngredients: ['Water', 'Oats', 'Rapeseed oil', 'Calcium Carbonate', 'Sea Salt'],
      );

      final report = await repo.analyzeProductIngredients(product);

      expect(report.totalCount, 5);
      expect(report.safeCount, 4); // Water, Oats, Calcium Carbonate, Sea Salt
      expect(report.attentionCount, 1); // Rapeseed oil
      expect(report.harmfulCount, 0);
      expect(report.countSummary, '4 Safe, 1 Attention');
    });

    test('Flagged harmful ingredient (e.g. Palm oil / Artificial color) is caught', () async {
      final firebaseService = FirebaseService();
      final dataSource = IngredientAnalysisDataSourceImpl(firebaseService);
      final repo = IngredientAnalysisRepositoryImpl(dataSource);

      const product = Product(
        id: 'flagged_product',
        barcode: '87654321',
        name: 'Processed Cocoa',
        brand: 'Nestlé',
        imageUrl: '',
        rawIngredients: ['Sugar', 'Cocoa', 'Palm oil derivatives', 'Caramel Color E150d'],
        isBoycotted: true,
      );

      final report = await repo.analyzeProductIngredients(product);

      expect(report.harmfulCount, greaterThan(0));
      expect(report.boycottFreePercentage, 0.0);
    });
  });

  group('ScanEth AI Boycott Verification Tests', () {
    test('BoycottDataSource correctly flags Nestle on recognized boycott lists', () async {
      final firebaseService = FirebaseService();
      final dataSource = BoycottDataSourceImpl(firebaseService);
      final repo = BoycottCheckRepositoryImpl(dataSource);

      final record = await repo.checkBrand('Nestlé');

      expect(record.isFlagged, true);
      expect(record.boycottLists, contains('Corporate Accountability Boycott list'));
      expect(record.primaryIssue, contains('Specific labor rights'));
    });

    test('BoycottDataSource verifies ethical brands as boycott-free', () async {
      final firebaseService = FirebaseService();
      final dataSource = BoycottDataSourceImpl(firebaseService);
      final repo = BoycottCheckRepositoryImpl(dataSource);

      final record = await repo.checkBrand('Oatly');

      expect(record.isFlagged, false);
      expect(record.boycottLists.isEmpty, true);
    });
  });

  group('ScanEth AI Ethical Recommendations Tests', () {
    test('RecommendationsDataSource returns certified alternatives with tags', () async {
      final firebaseService = FirebaseService();
      final dataSource = RecommendationsDataSourceImpl(firebaseService);
      final repo = RecommendationsRepositoryImpl(dataSource);

      const product = Product(
        id: 'nesquik',
        barcode: '7613035345678',
        name: 'Nesquik Chocolate Drink Mix',
        brand: 'Nestlé',
        imageUrl: '',
        isBoycotted: true,
      );

      final alternatives = await repo.getAlternativesForProduct(product);

      expect(alternatives.isNotEmpty, true);
      final firstAlt = alternatives.first;
      expect(firstAlt.tagBadges, contains('🟢 Boycott-Free'));
      expect(firstAlt.tagBadges, contains('🟢 Sustainable Sourcing'));
      expect(firstAlt.ethicsScore, greaterThan(9.0));
      expect(firstAlt.comparisonMetric.isNotEmpty, true);
    });
  });
}
