---
name: flutter-clean-arch
description: >
  Flutter clean architecture guide for this template. Use when creating features,
  screens, state managers (providers/blocs/cubits/controllers), use cases, repositories,
  models, or entities. Also use when asked about project structure, conventions,
  or architecture decisions.
---

# Flutter Clean Architecture Template

This project follows **Clean Architecture** with feature-based modular structure. Every feature is split into three layers with strict dependency rules.

## Project Structure

```
lib/
├── app/                          # App entry point, DI container, main widget
│   ├── app_name.dart             # MaterialApp with GoRouter
│   └── injection_container.dart  # Global GetIt DI setup
│
├── core/                         # Shared code across all features
│   ├── config/                   # Responsive scaling config
│   ├── constants/                # App-wide constants, asset paths
│   ├── entities/                 # Shared domain entities
│   ├── enums/                    # Global enums
│   ├── extensions/               # Context, responsive, string, widget extensions
│   ├── providers/                # Global state (theme, etc.)
│   ├── router/                   # GoRouter config, route names, transitions
│   ├── services/                 # Dio HTTP, local storage, logger, network, notifications
│   ├── theme/                    # Colors, text styles, theme data
│   ├── utils/                    # Validators, system utilities
│   └── widgets/                  # Reusable UI components (buttons, inputs, loaders, etc.)
│
└── features/                     # Feature modules
    └── <feature_name>/
        ├── data/                 # Data layer
        │   ├── models/           # DTOs with fromJson/toJson/toEntity
        │   ├── datasources/      # Remote & local data sources
        │   └── repositories/     # Repository implementations
        ├── domain/               # Domain layer (pure Dart)
        │   ├── entities/         # Business objects
        │   ├── repositories/     # Repository interfaces (abstract)
        │   └── usecases/         # Business logic
        ├── presentation/         # Presentation layer
        │   ├── screens/          # Full screens/pages
        │   ├── widgets/          # Feature-specific widgets
        │   └── <state_mgmt>/     # State managers (providers/blocs/cubits/controllers)
        └── <feature>_di.dart     # Feature-level DI registration
```

## Three-Layer Rule

| Layer | Depends on | Contains | Rules |
|---|---|---|---|
| **Domain** | Nothing | Entities, repository interfaces, use cases | Pure Dart only. NO Flutter imports. NO external packages. |
| **Data** | Domain | Models, datasources, repository impls | Can use Dio, HTTP, databases. NO Flutter UI code. |
| **Presentation** | Domain | Screens, widgets, state managers | Uses use cases, never repositories directly. |

**Dependency direction:** Presentation → Domain ← Data. Domain knows nothing about the others.

## State Management

This template does **not** enforce a specific state management solution. Use whatever your team prefers:
- **Provider** (ChangeNotifier)
- **BLoC/Cubit** (flutter_bloc)
- **GetX** (Controller)
- **Riverpod**
- **MobX**
- Or any other approach

The key rule: state managers live in `presentation/` and call **use cases** — never repositories directly.

## Dependency Injection (GetIt)

- Global instance: `final di = GetIt.instance;`
- **State managers** → `registerFactory()` (new instance per screen)
- **Use cases** → `registerLazySingleton()` (shared singleton)
- **Repositories** → `registerLazySingleton()` (register as interface type)
- **DataSources** → `registerLazySingleton()` (register as interface type)
- Each feature has its own `<feature>_di.dart` class, called from `injection_container.dart`

## Available Core Utilities

Before writing new code, check if these already solve your need:

- **Extensions**: `context.colorScheme`, `context.textTheme`, `context.hideKeyboard()`, `.h`, `.w`, `.sp`, `.r`, `.ht`, `.wt`, `.paddingAll()`, `.marginSymmetric()`, `.capitalize()`, `.isEmail`
- **Widgets**: `CustomTextField`, `PrimaryButton`, `CustomLoader`, `ShimmerLoader`, `CustomDialog`, `CustomSnackBar`, `CustomCard`, `AppBackButton`, `ConnectivityWidget`
- **Services**: `DioClient` (HTTP), `LocalStorageService` (secure storage), `LoggerService` (structured logging), `NetworkService` (connectivity), `ImagePickerService`
- **Validators**: `Validators.validateEmail()`, `.validatePassword()`, `.validateName()`, `.validatePhone()`, `.validateRequired()`
- **Navigation**: `GoRouter` with `context.go()` / `context.push()`, route names in `RouteNames`
- **Theme**: `AppColors`, `AppTextStyle`, light/dark theme via `AppThemeData`

## Additional Resources

- For detailed layer rules and data flow, see [architecture-guide.md](architecture-guide.md)
- For step-by-step feature creation with code templates, see [feature-scaffold.md](feature-scaffold.md)
- For naming, DI, and coding conventions, see [conventions.md](conventions.md)
