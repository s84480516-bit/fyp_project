# Auth Dependency Injection

This file is responsible for registering **all dependencies** related to
the authentication feature using **GetIt**.

## Responsibilities
- Register providers (ChangeNotifiers)
- Register use cases
- Register repositories
- Register data sources

## Why this exists
- Keeps feature dependencies isolated
- Improves scalability
- Makes features plug-and-play

## Registration Rules
- Providers → registerFactory
- UseCases → registerLazySingleton
- Repositories → registerLazySingleton
- DataSources → registerLazySingleton

## Example
```dart
class AuthDi {
  void init() {
    di.registerFactory(() => LoginProvider(di()));
    di.registerLazySingleton(() => LoginUseCase(di()));
    di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(di()),
    );
    di.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(di()),
    );
  }
}