# Feature Scaffold Guide

Follow these steps to add a new feature. Replace `<Name>` with your feature name in PascalCase and `<name>` in snake_case.

---

## Step 1: Create Folder Structure

```
lib/features/<name>/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── <state_mgmt>/        # providers/ or blocs/ or cubits/ or controllers/ etc.
└── <name>_di.dart
```

---

## Step 2: Domain Layer (create first — no dependencies)

### Entity (`domain/entities/<name>_entity.dart`)

```dart
class <Name>Entity {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  <Name>Entity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  @override
  String toString() => '<Name>Entity(id: $id, title: $title)';
}
```

### Repository Interface (`domain/repositories/<name>_repository.dart`)

```dart
abstract class <Name>Repository {
  Future<List<<Name>Entity>> getAll();
  Future<<Name>Entity> getById(String id);
  Future<void> create(<Name>Entity entity);
  Future<void> update(<Name>Entity entity);
  Future<void> delete(String id);
}
```

### Use Cases (`domain/usecases/`)

Create one file per use case. Each use case does one thing.

**`get_all_<name>s_usecase.dart`**:
```dart
class GetAll<Name>sUseCase {
  final <Name>Repository repository;

  GetAll<Name>sUseCase(this.repository);

  Future<List<<Name>Entity>> call() {
    return repository.getAll();
  }
}
```

**`get_<name>_by_id_usecase.dart`**:
```dart
class Get<Name>ByIdUseCase {
  final <Name>Repository repository;

  Get<Name>ByIdUseCase(this.repository);

  Future<<Name>Entity> call(String id) {
    return repository.getById(id);
  }
}
```

**`create_<name>_usecase.dart`**:
```dart
class Create<Name>UseCase {
  final <Name>Repository repository;

  Create<Name>UseCase(this.repository);

  Future<void> call(<Name>Entity entity) {
    return repository.create(entity);
  }
}
```

---

## Step 3: Data Layer (implements domain contracts)

### Model (`data/models/<name>_model.dart`)

```dart
import '../../domain/entities/<name>_entity.dart';

class <Name>Model {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  <Name>Model({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory <Name>Model.fromJson(Map<String, dynamic> json) {
    return <Name>Model(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  <Name>Entity toEntity() {
    return <Name>Entity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
    );
  }
}
```

### DataSource (`data/datasources/<name>_remote_datasource.dart`)

```dart
import 'package:dio/dio.dart';
import '../models/<name>_model.dart';
import '../../../../core/services/dio/dio_client.dart';
import '../../../../core/services/dio/dio_exceptions.dart';
import '../../../../core/services/dio/endpoints.dart';

abstract class <Name>RemoteDataSource {
  Future<List<<Name>Model>> getAll();
  Future<<Name>Model> getById(String id);
  Future<void> create(Map<String, dynamic> data);
  Future<void> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
}

class <Name>RemoteDataSourceImpl implements <Name>RemoteDataSource {
  final DioClient dioClient;

  <Name>RemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<<Name>Model>> getAll() async {
    try {
      final response = await dioClient.get(Endpoints.<name>s);
      return (response as List)
          .map((e) => <Name>Model.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }

  @override
  Future<<Name>Model> getById(String id) async {
    try {
      final response = await dioClient.get('${Endpoints.<name>s}/$id');
      return <Name>Model.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }

  @override
  Future<void> create(Map<String, dynamic> data) async {
    try {
      await dioClient.post(Endpoints.<name>s, data: data);
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await dioClient.put('${Endpoints.<name>s}/$id', data: data);
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await dioClient.delete('${Endpoints.<name>s}/$id');
    } catch (e) {
      throw DioExceptions.fromDioError(e as DioException);
    }
  }
}
```

### Repository Implementation (`data/repositories/<name>_repository_impl.dart`)

```dart
import '../../domain/entities/<name>_entity.dart';
import '../../domain/repositories/<name>_repository.dart';
import '../datasources/<name>_remote_datasource.dart';

class <Name>RepositoryImpl implements <Name>Repository {
  final <Name>RemoteDataSource remoteDataSource;

  <Name>RepositoryImpl(this.remoteDataSource);

  @override
  Future<List<<Name>Entity>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<<Name>Entity> getById(String id) async {
    final model = await remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<void> create(<Name>Entity entity) async {
    await remoteDataSource.create({
      'title': entity.title,
      'description': entity.description,
    });
  }

  @override
  Future<void> update(<Name>Entity entity) async {
    await remoteDataSource.update(entity.id, {
      'title': entity.title,
      'description': entity.description,
    });
  }

  @override
  Future<void> delete(String id) async {
    await remoteDataSource.delete(id);
  }
}
```

---

## Step 4: Presentation Layer

### State Manager

Create a state manager using your project's chosen state management approach. It must:
- Accept use case(s) via constructor (injected through DI)
- Hold UI state: loading flag, error message, data
- Call use cases to execute business logic
- Notify the UI when state changes

Place it in `presentation/providers/`, `presentation/blocs/`, `presentation/cubits/`, or `presentation/controllers/` — whichever your project uses.

**Example using ChangeNotifier (Provider):**
```dart
import 'package:flutter/material.dart';
import '../../domain/entities/<name>_entity.dart';
import '../../domain/usecases/get_all_<name>s_usecase.dart';

class <Name>Provider extends ChangeNotifier {
  final GetAll<Name>sUseCase _getAll<Name>sUseCase;

  bool _isLoading = false;
  String? _error;
  List<<Name>Entity> _items = [];

  <Name>Provider(this._getAll<Name>sUseCase);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<<Name>Entity> get items => _items;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _getAll<Name>sUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**Example using BLoC/Cubit:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/<name>_entity.dart';
import '../../domain/usecases/get_all_<name>s_usecase.dart';

class <Name>Cubit extends Cubit<<Name>State> {
  final GetAll<Name>sUseCase _getAll<Name>sUseCase;

  <Name>Cubit(this._getAll<Name>sUseCase) : super(<Name>Initial());

  Future<void> loadAll() async {
    emit(<Name>Loading());
    try {
      final items = await _getAll<Name>sUseCase();
      emit(<Name>Loaded(items));
    } catch (e) {
      emit(<Name>Error(e.toString()));
    }
  }
}

abstract class <Name>State {}
class <Name>Initial extends <Name>State {}
class <Name>Loading extends <Name>State {}
class <Name>Loaded extends <Name>State {
  final List<<Name>Entity> items;
  <Name>Loaded(this.items);
}
class <Name>Error extends <Name>State {
  final String message;
  <Name>Error(this.message);
}
```

### Screen (`presentation/screens/<name>_screen.dart`)

Create a page widget that sets up state management, and a view widget for the UI. Adapt the state management wrapper to your project's approach.

```dart
import 'package:flutter/material.dart';
import '../../../../app/injection_container.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/loaders/custom_loader.dart';

// Wrap with your state management (ChangeNotifierProvider, BlocProvider, etc.)
// and build the UI consuming the state manager.

class <Name>Page extends StatelessWidget {
  const <Name>Page({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your state management provider wrapper:
    // e.g., ChangeNotifierProvider(create: (_) => di<<Name>Provider>()..loadAll(), child: const <Name>View())
    // e.g., BlocProvider(create: (_) => di<<Name>Cubit>()..loadAll(), child: const <Name>View())
    return const <Name>View();
  }
}

class <Name>View extends StatelessWidget {
  const <Name>View({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your state consumer:
    // e.g., Consumer<<Name>Provider>(builder: ...)
    // e.g., BlocBuilder<<Name>Cubit, <Name>State>(builder: ...)
    return Scaffold(
      appBar: AppBar(title: const Text('<Name>')),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 0, // items.length
        itemBuilder: (context, index) {
          // Build list item
          return const SizedBox();
        },
      ),
    );
  }
}
```

---

## Step 5: Feature DI (`<name>_di.dart`)

Register all feature dependencies. Adapt the state manager registration to your approach.

```dart
import '../../app/injection_container.dart';
import 'data/datasources/<name>_remote_datasource.dart';
import 'data/repositories/<name>_repository_impl.dart';
import 'domain/repositories/<name>_repository.dart';
import 'domain/usecases/get_all_<name>s_usecase.dart';

class <Name>Di {
  void init() {
    // State manager (registerFactory — new instance per screen)
    // For Provider:  di.registerFactory(() => <Name>Provider(di()));
    // For Cubit:     di.registerFactory(() => <Name>Cubit(di()));
    // For GetX:      di.registerFactory(() => <Name>Controller(di()));

    // Use cases (lazySingleton — shared across the app)
    di.registerLazySingleton(() => GetAll<Name>sUseCase(di()));

    // Repository (lazySingleton — register as interface type)
    di.registerLazySingleton<<Name>Repository>(
      () => <Name>RepositoryImpl(di()),
    );

    // DataSource (lazySingleton — register as interface type)
    di.registerLazySingleton<<Name>RemoteDataSource>(
      () => <Name>RemoteDataSourceImpl(di()),
    );
  }
}
```

---

## Step 6: Wire It Up

### Register in `lib/app/injection_container.dart`

Add the import and call `init()`:

```dart
import '../features/<name>/<name>_di.dart';

// Inside initializeDependencies():
<Name>Di().init();
```

### Add Route in `lib/core/router/app_router.dart`

Add a `GoRoute` entry:

```dart
GoRoute(
  path: RouteNames.<name>,
  builder: (context, state) => const <Name>Page(),
),
```

And add the route name in `lib/core/router/route_names.dart`:

```dart
static const String <name> = '/<name>';
```

### Add Endpoint in `lib/core/services/dio/endpoints.dart`

```dart
static const String <name>s = '/<name>s';
```

---

## Checklist

- [ ] Domain: Entity created
- [ ] Domain: Repository interface created
- [ ] Domain: Use case(s) created
- [ ] Data: Model with fromJson/toJson/toEntity created
- [ ] Data: DataSource interface + impl created
- [ ] Data: Repository impl created
- [ ] Presentation: State manager created
- [ ] Presentation: Screen created
- [ ] Feature DI class created and registered in injection_container.dart
- [ ] Route added in app_router.dart and route_names.dart
- [ ] Endpoint added in endpoints.dart
