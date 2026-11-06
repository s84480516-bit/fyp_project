import 'package:get_it/get_it.dart';
import '../core/providers/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/services/network/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/services/image picker/image_picker_service.dart';
import '../core/services/local storage/local_storage_service.dart';
import '../core/services/dio/dio_client.dart';
import '../core/services/firebase/firebase_service.dart';
import '../features/auth/auth_di.dart';
import '../features/product_scanner/product_scanner_di.dart';
import '../features/ingredient_analysis/ingredient_analysis_di.dart';
import '../features/boycott_check/boycott_check_di.dart';
import '../features/recommendations/recommendations_di.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  // Local Storage Service
  di.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Image Picker Service
  di.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(picker: ImagePicker()),
  );

  // Connectivity
  di.registerLazySingleton(() => Connectivity());

  // Network Service
  di.registerLazySingleton<NetworkService>(() => NetworkService(di()));

  // Theme Provider Registering
  di.registerLazySingleton(() => ThemeProvider());

  // Dio Client for Open Food Facts API
  di.registerLazySingleton<DioClient>(() => DioClient());

  // Firebase Service
  final firebaseService = FirebaseService();
  await firebaseService.initialize();
  di.registerSingleton<FirebaseService>(firebaseService);

  // Feature Dependencies (Clean Architecture)
  AuthDi().init();
  ProductScannerDi().init();
  IngredientAnalysisDi().init();
  BoycottCheckDi().init();
  RecommendationsDi().init();
}
