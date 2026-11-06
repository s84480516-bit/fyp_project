import '../../../app/injection_container.dart';
import 'data/datasources/boycott_data_source.dart';
import 'data/repositories/boycott_check_repository_impl.dart';
import 'domain/repositories/boycott_check_repository.dart';
import 'domain/usecases/check_boycott_status_usecase.dart';
import 'presentation/providers/boycott_check_provider.dart';

class BoycottCheckDi {
  void init() {
    // Data Source
    di.registerLazySingleton<BoycottDataSource>(
      () => BoycottDataSourceImpl(di()),
    );

    // Repository
    di.registerLazySingleton<BoycottCheckRepository>(
      () => BoycottCheckRepositoryImpl(di()),
    );

    // Use Case
    di.registerLazySingleton(() => CheckBoycottStatusUseCase(di()));

    // Provider
    di.registerFactory(
      () => BoycottCheckProvider(
        checkBoycottStatusUseCase: di(),
        getAlternativesUseCase: di(),
      ),
    );
  }
}
