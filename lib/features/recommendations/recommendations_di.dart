import '../../../app/injection_container.dart';
import 'data/datasources/recommendations_data_source.dart';
import 'data/repositories/recommendations_repository_impl.dart';
import 'domain/repositories/recommendations_repository.dart';
import 'domain/usecases/get_alternatives_usecase.dart';
import 'presentation/providers/recommendations_provider.dart';

class RecommendationsDi {
  void init() {
    // Data Source
    di.registerLazySingleton<RecommendationsDataSource>(
      () => RecommendationsDataSourceImpl(di()),
    );

    // Repository
    di.registerLazySingleton<RecommendationsRepository>(
      () => RecommendationsRepositoryImpl(di()),
    );

    // Use Case
    di.registerLazySingleton(() => GetAlternativesUseCase(di()));

    // Provider
    di.registerFactory(() => RecommendationsProvider(di()));
  }
}
