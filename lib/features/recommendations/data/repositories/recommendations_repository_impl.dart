import 'package:cleanarchitecturetemplate/features/product_scanner/domain/entities/product.dart';
import '../../domain/entities/alternative_product.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_data_source.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsDataSource _dataSource;

  RecommendationsRepositoryImpl(this._dataSource);

  @override
  Future<List<AlternativeProduct>> getAlternativesForProduct(Product originalProduct) async {
    return await _dataSource.getAlternatives(originalProduct);
  }
}
