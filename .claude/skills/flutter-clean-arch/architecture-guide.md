# Architecture Guide

## Layer Rules

### Domain Layer (`features/*/domain/`)

The innermost layer. Pure Dart — no Flutter, no external packages.

**Entities** (`domain/entities/`):
- Plain Dart classes representing business objects
- Contain fields, computed properties, helper methods
- No framework dependencies, no JSON serialization
- Example: `UserEntity` with `id`, `name`, `email` fields

**Repository Interfaces** (`domain/repositories/`):
- Abstract classes defining data contracts
- The domain layer only knows about these abstractions
- Data layer provides the concrete implementations

```dart
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<void> logout();
}
```

**Use Cases** (`domain/usecases/`):
- Single-responsibility classes encapsulating one business operation
- Constructor receives repository interface via DI
- Expose a `call()` method to execute the operation
- Keep use cases focused — one use case per action

```dart
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
```

---

### Data Layer (`features/*/data/`)

Implements domain contracts. Can use external packages (Dio, databases, etc.). No Flutter UI code.

**Models / DTOs** (`data/models/`):
- Mirror entities but add serialization
- Must have: `fromJson()`, `toJson()`, `toEntity()`
- Models convert API responses into domain entities

```dart
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  UserEntity toEntity() => UserEntity(id: id, name: name, email: email);
}
```

**Data Sources** (`data/datasources/`):
- Abstract interface + concrete `Impl` class
- Remote datasources use `DioClient` for API calls
- Local datasources use `LocalStorageService` or databases
- Wrap API calls in try-catch, throw `DioExceptions`

```dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response);
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }
}
```

**Repository Implementations** (`data/repositories/`):
- Implements the domain repository interface
- Delegates to datasource(s), converts models to entities
- Can coordinate between remote and local datasources (caching, offline)

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final model = await remoteDataSource.login(email, password);
    return model.toEntity();
  }
}
```

---

### Presentation Layer (`features/*/presentation/`)

Flutter UI and state management. Depends on domain layer via use cases.

**State Managers** (`presentation/providers/` or `presentation/blocs/` or equivalent):
- Use whatever state management the project adopts (Provider, BLoC, GetX, Riverpod, etc.)
- Hold UI state: loading, error, data
- Call **use cases** to execute business logic — never call repositories directly
- Notify the UI when state changes

**Screens** (`presentation/screens/`):
- Page-level widgets that set up state management and layout
- Wrap with state management provider (e.g., `ChangeNotifierProvider`, `BlocProvider`, etc.)
- Use responsive extensions for all dimensions (`.h`, `.w`, `.sp`, `.r`)

**Widgets** (`presentation/widgets/`):
- Feature-specific reusable widgets
- For cross-feature widgets, use `core/widgets/` instead

---

## Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION                             │
│  UI Action → State Manager → calls Use Case                    │
│  State Manager ← notifies UI ← receives result                │
└──────────────────────────┬──────────────────────────────────────┘
                           │ depends on
┌──────────────────────────▼──────────────────────────────────────┐
│                          DOMAIN                                 │
│  UseCase.call() → Repository interface method                  │
│  Returns Entity ← Repository returns Entity                   │
└──────────────────────────▲──────────────────────────────────────┘
                           │ implements
┌──────────────────────────┴──────────────────────────────────────┐
│                           DATA                                  │
│  RepositoryImpl → DataSource.apiCall() → API / Database        │
│  Model.fromJson(response) → Model.toEntity() → Entity         │
└─────────────────────────────────────────────────────────────────┘
```

**Request flow:** UI Action → State Manager → UseCase → Repository → DataSource → API
**Response flow:** API → DataSource → Model → Repository → Entity → State Manager → UI rebuilds

---

## Error Handling

1. **DataSources**: Catch `DioException`, convert to `DioExceptions` using `DioExceptions.fromDioError()`
2. **Repositories**: Can add additional error mapping or let exceptions propagate
3. **State Managers**: Catch exceptions in try-catch, store error message in state, notify UI
4. **UI**: Display errors via `CustomSnackBar` or inline error widgets

```
API error → DioExceptions.fromDioError() → propagates → State Manager catches → sets error state → UI shows error
```

---

## Dependency Direction Summary

```
Presentation ──depends on──▶ Domain ◀──implements── Data
     │                         │                      │
  Screens                   Entities              Models
  Widgets                   Repo interfaces       DataSources
  State Managers            Use Cases             Repo Impls
```

**Golden rule:** Domain layer has ZERO dependencies on Data or Presentation. It defines interfaces that others implement or consume.
