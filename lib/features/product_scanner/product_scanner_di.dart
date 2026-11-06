import '../../../app/injection_container.dart';
import 'data/datasources/product_local_data_source.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_product_by_barcode_usecase.dart';
import 'domain/usecases/get_recent_scans_usecase.dart';
import 'domain/usecases/search_products_usecase.dart';
import 'presentation/providers/scanner_provider.dart';

class ProductScannerDi {
  void init() {
    // Data Sources
    di.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(di()),
    );
    di.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(di()),
    );

    // Repository
    di.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: di(),
        localDataSource: di(),
      ),
    );

    // Use cases
    di.registerLazySingleton(() => GetProductByBarcodeUseCase(di()));
    di.registerLazySingleton(() => SearchProductsUseCase(di()));
    di.registerLazySingleton(() => GetRecentScansUseCase(di()));
    di.registerLazySingleton(() => SaveScanUseCase(di()));

    // Provider
    di.registerFactory(
      () => ScannerProvider(
        getProductByBarcodeUseCase: di(),
        searchProductsUseCase: di(),
        getRecentScansUseCase: di(),
      ),
    );
  }
}
