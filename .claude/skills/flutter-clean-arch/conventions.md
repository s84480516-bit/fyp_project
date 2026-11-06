# Conventions

## File Naming

- All Dart files use `snake_case.dart`
- Entities: `<name>_entity.dart`
- Models: `<name>_model.dart`
- Repository interfaces: `<name>_repository.dart`
- Repository implementations: `<name>_repository_impl.dart`
- DataSource interfaces + impls: `<name>_remote_datasource.dart`
- Use cases: `<action>_<name>_usecase.dart` (e.g., `login_usecase.dart`, `get_all_products_usecase.dart`)
- State managers: `<name>_provider.dart`, `<name>_cubit.dart`, `<name>_bloc.dart`, or `<name>_controller.dart`
- Screens: `<name>_screen.dart`
- Feature DI: `<feature>_di.dart`
- Services: `<name>_service.dart`

## Class Naming

- All classes use `PascalCase`
- Interfaces: plain name, **no** `I` prefix (e.g., `AuthRepository`, not `IAuthRepository`)
- Implementations: `<Name>Impl` suffix (e.g., `AuthRepositoryImpl`, `AuthRemoteDataSourceImpl`)
- State managers: `<Name>Provider`, `<Name>Cubit`, `<Name>Bloc`, or `<Name>Controller`
- DI classes: `<Name>Di` (e.g., `AuthDi`, `ProductDi`)

## Dependency Injection (GetIt)

Global instance: `final di = GetIt.instance;`

| What | Registration | Why |
|---|---|---|
| State managers (providers/blocs/cubits/controllers) | `registerFactory()` | New instance per screen |
| Use cases | `registerLazySingleton()` | Shared singleton, lazy-loaded |
| Repositories | `registerLazySingleton<Interface>()` | Register as interface type |
| DataSources | `registerLazySingleton<Interface>()` | Register as interface type |
| Core services | `registerLazySingleton()` | App-wide singletons |

**Retrieval:** `di<ClassName>()` — e.g., `di<LoginUseCase>()`

## Responsive Sizing

**Never hardcode pixel values.** Always use responsive extensions:

| Extension | Purpose | Example |
|---|---|---|
| `.h` | Responsive height | `16.h` |
| `.w` | Responsive width | `20.w` |
| `.sp` | Responsive font size | `14.sp` |
| `.r` | Responsive radius | `8.r` |
| `.ht` | SizedBox with height | `10.ht` (instead of `SizedBox(height: 10)`) |
| `.wt` | SizedBox with width | `8.wt` (instead of `SizedBox(width: 8)`) |

## Context Extensions

Use these instead of verbose `Theme.of(context)` calls:

```dart
context.colorScheme        // Theme.of(context).colorScheme
context.textTheme          // Theme.of(context).textTheme
context.theme              // Theme.of(context)
context.hideKeyboard()     // FocusScope.of(context).unfocus()
context.isKeyboardVisible  // MediaQuery viewInsets check
```

## Widget Extensions

Use fluent API for padding, margin, alignment:

```dart
widget.paddingAll(16)                    // Padding on all sides
widget.paddingSymmetric(h: 16, v: 8)    // Symmetric padding
widget.paddingOnly(left: 10, top: 5)    // Specific sides
widget.marginAll(8)                      // Margin on all sides
widget.marginSymmetric(h: 16)           // Symmetric margin
widget.center                           // Center widget
widget.align(Alignment.topRight)        // Align widget
widget.expanded                         // Expanded widget
```

## String Extensions

```dart
"hello".capitalize()     // "Hello"
"hello world".titleCase  // "Hello World"
"test@email.com".isEmail // true
"hello".truncate(3)      // "hel..."
```

## List Extensions

```dart
list.isNullOrEmpty    // null or empty check
```

## Theme & Colors

- Use `AppColors` for color constants: `AppColors.primary`, `AppColors.error`, `AppColors.darkBackground`
- Access theme colors via: `context.colorScheme.primary`, `context.colorScheme.surface`
- Access text styles via: `context.textTheme.bodyLarge`, `context.textTheme.titleMedium`
- **Never hardcode color values** — always use `AppColors` or `context.colorScheme`

## Reusable Widgets

Check `core/widgets/` before creating new widgets. Available:

| Widget | Location | Purpose |
|---|---|---|
| `CustomTextField` | `core/widgets/inputs/` | Text input with built-in validation by field type |
| `SearchField` | `core/widgets/inputs/` | Search input field |
| `PrimaryButton` | `core/widgets/animated/` | Main button with loading state |
| `AnimatedButton` | `core/widgets/animated/` | Button with tap animation |
| `OutlinedButton` | `core/widgets/animated/` | Outlined button variant |
| `CustomLoader` | `core/widgets/loaders/` | Loading spinner |
| `ShimmerLoader` | `core/widgets/loaders/` | Shimmer loading placeholder |
| `CustomDialog` | `core/widgets/dialogs/` | Alert/confirmation dialog |
| `CustomSnackBar` | `core/widgets/snackbars/` | Styled snackbar (success, error, warning, info) |
| `CustomCard` | `core/widgets/cards/` | Styled card widget |
| `AppBackButton` | `core/widgets/buttons/` | Back navigation button |
| `CustomIconButton` | `core/widgets/buttons/` | Icon button |
| `CustomTextButton` | `core/widgets/buttons/` | Text button |
| `CustomFloatingActionButton` | `core/widgets/buttons/` | FAB |
| `ConnectivityWidget` | `core/widgets/more/` | Network status indicator |
| `CustomImageWidget` | `core/widgets/more/` | Image with loading/error handling |
| `CustomAppbarWidget` | `core/widgets/more/` | Custom app bar |
| `FadeInWidget` | `core/widgets/animated/` | Fade-in animation wrapper |
| `SlideTransitionWidget` | `core/widgets/animated/` | Slide animation wrapper |
| `AnimatedListItem` | `core/widgets/animated/` | List item with entrance animation |

## Validators

Use `Validators` from `core/utils/validators.dart`:

```dart
Validators.validateEmail(value)                      // Email format
Validators.validatePassword(value)                   // Min length, uppercase, lowercase, digit
Validators.validateName(value)                       // Min/max length
Validators.validatePhone(value)                      // Phone number
Validators.validateRequired(value, 'Field Name')     // Non-empty check
Validators.validateNumberOnly(value, 'Field Name')   // Numbers only
Validators.validateUrl(value)                        // URL format
Validators.validateConfirmPassword(value, password)  // Password match
```

## Logger

Create a logger instance per class:

```dart
final logger = LoggerService(className: 'MyClassName');

logger.debug('Debug message');                    // Debug (only in debug mode)
logger.info('Info message');                       // Info
logger.warning('Warning message');                 // Warning
logger.success('Operation completed');             // Success
logger.error('Failed', error: e, stackTrace: st);  // Error
logger.critical('Critical failure', error: e);     // Critical
logger.network('POST /api/data', data: body);      // Network (debug only)
logger.provider('State changed');                  // State changes (debug only)
logger.navigation('Navigating to Home');           // Navigation (debug only)
```

## Navigation (GoRouter)

```dart
context.go(RouteNames.home);           // Replace current route
context.push(RouteNames.details);      // Push new route
context.pop();                         // Go back
```

Route names are constants in `core/router/route_names.dart`.
Route config is in `core/router/app_router.dart`.

## Error Handling

- **DataSources**: `throw DioExceptions.fromDioError(e as DioException);`
- **State managers**: wrap use case calls in try-catch, store `e.toString()` as error state
- **UI**: show errors via `CustomSnackBar` or inline error text

## Constants

Use `AppConstants` from `core/constants/app_constants.dart`:

```dart
AppConstants.hPadding          // Default horizontal padding (responsive)
AppConstants.vPadding          // Default vertical padding (responsive)
AppConstants.borderRadius      // Default border radius (responsive)
AppConstants.shortAnimation    // 200ms duration
AppConstants.mediumAnimation   // 400ms duration
AppConstants.longAnimation     // 600ms duration
```
