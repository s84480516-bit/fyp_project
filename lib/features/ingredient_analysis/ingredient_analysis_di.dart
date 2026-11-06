import '../../../app/injection_container.dart';
import 'data/datasources/ingredient_analysis_data_source.dart';
import 'data/repositories/ingredient_analysis_repository_impl.dart';
import 'domain/repositories/ingredient_analysis_repository.dart';
import 'domain/usecases/analyze_ingredients_usecase.dart';
import 'presentation/providers/ingredient_analysis_provider.dart';

class IngredientAnalysisDi {
  void init() {
    // Data Source
    di.registerLazySingleton<IngredientAnalysisDataSource>(
      () => IngredientAnalysisDataSourceImpl(di()),
    );

    // Repository
    di.registerLazySingleton<IngredientAnalysisRepository>(
      () => IngredientAnalysisRepositoryImpl(di()),
    );

    // Use cases
    di.registerLazySingleton(() => AnalyzeIngredientsUseCase(di()));

    // Provider
    di.registerFactory(() => IngredientAnalysisProvider(di()));
  }
}
