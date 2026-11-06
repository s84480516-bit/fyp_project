# Flutter Clean Architecture Template

A **production-ready Flutter project template** designed with Clean Architecture principles. It implements SOLID principles, MVVM concepts, and feature-based structure using **Provider** for state management and **GetIt** for dependency injection.

This template is fully modular, scalable, and includes pre-built services, widgets, and configurations that accelerate development while maintaining clean code practices.

---

## Project Structure

```text
lib/
├── main.dart                     # App entry point
├── app/
│   ├── app_name.dart             # Main App widget with MultiProvider
│   └── injection_container.dart  # Global DI container (GetIt)
├── core/
│   ├── config/
│   │   └── responsive_config.dart    # Responsive scaling system
│   ├── constants/
│   │   ├── app_assets.dart           # Asset paths management
│   │   └── app_constants.dart        # App-wide constants
│   ├── entities/
│   │   └── image_info_entity.dart    # Shared entities
│   ├── enums/
│   │   └── app_enums.dart            # Global enums
│   ├── extensions/
│   │   ├── context_extensions.dart   # BuildContext extensions
│   │   ├── helper_extensions.dart    # General helper extensions
│   │   ├── responsive_extension.dart # Responsive extensions
│   │   ├── string_extensions.dart    # String utilities
│   │   └── widget_extensions.dart    # Widget extensions
│   ├── providers/
│   │   └── theme_provider.dart       # Theme management provider
│   ├── router/
│   │   ├── app_router.dart           # GoRouter configuration
│   │   ├── route_names.dart          # Route constants
│   │   └── route_transitions.dart    # Custom route animations
│   ├── services/
│   │   ├── dio/
│   │   │   ├── dio_client.dart       # Dio HTTP client
│   │   │   ├── dio_exceptions.dart   # Error handling
│   │   │   ├── endpoints.dart        # API endpoints
│   │   │   ├── interceptors/         # Request/Response interceptors
│   │   │   ├── network.dart          # Network utilities
│   │   │   └── refresh token/        # Token refresh logic
│   │   ├── image picker/
│   │   │   └── image_picker_service.dart
│   │   ├── local storage/
│   │   │   └── local_storage_service.dart
│   │   ├── logger/
│   │   │   └── logger_service.dart   # Logging utility
│   │   ├── network/
│   │   │   └── network_service.dart  # Connectivity checking
│   │   └── notifications/
│   │       └── notifications_service.dart
│   ├── theme/
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_text_style.dart       # Typography
│   │   ├── app_theme.dart            # Theme configuration
│   │   └── app_theme_data.dart       # Theme data
│   ├── utils/
│   │   ├── system_utils.dart         # System UI utilities
│   │   └── validators.dart           # Form validators
│   └── widgets/
│       ├── animated/                 # Animated widgets
│       │   ├── animated_button.dart
│       │   ├── animated_list_item.dart
│       │   ├── fade_in_widget.dart
│       │   ├── outlined_button.dart
│       │   ├── primary_button.dart
│       │   └── slide_transition_widget.dart
│       ├── bottom sheets/
│       │   └── custom_bottom_sheets.dart
│       ├── buttons/
│       │   ├── app_back_button.dart
│       │   ├── custom_floating_action_button.dart
│       │   ├── custom_icon_button.dart
│       │   └── custom_text_button.dart
│       ├── cards/
│       │   └── custom_card.dart
│       ├── dialogs/
│       │   └── custom_dialog.dart
│       ├── inputs/
│       │   ├── custom_text_field.dart
│       │   └── search_field.dart
│       ├── loaders/
│       │   ├── custom_loader.dart
│       │   └── shimmer_loader.dart
│       ├── snackbars/
│       │   └── custom_snackbars.dart
│       └── more/
│           ├── app_logo_widget.dart
│           ├── connectivity_widget.dart
│           ├── custom_appbar_widget.dart
│           ├── custom_image_widget.dart
│           ├── custom_shimmer_widget.dart
│           └── settings_listtile_widget.dart
└── features/
    └── auth/                     # Example feature (template structure)
        ├── data/                 # Models, repositories implementation, data sources
        ├── domain/               # Entities, use cases, repository contracts
        ├── presentation/         # Screens, widgets, providers (ChangeNotifier)
        └── auth_di.dart          # Feature-level dependency injection
```

---

## Key Features

### Architecture & Design
- **Clean Architecture**: Clear separation of concerns (data, domain, presentation)
- **Feature-based Structure**: Self-contained, modular features
- **SOLID Principles**: Maintainable and testable code
- **Provider State Management**: Reactive state handling with ChangeNotifier
- **GetIt Dependency Injection**: Clean, testable dependency management

### Routing & Navigation
- **GoRouter Integration**: Declarative routing with deep linking support
- **Custom Route Transitions**: Pre-built fade, slide, and other animations
- **Type-safe Navigation**: Route names as constants

### Theme System
- **Light & Dark Themes**: Complete theme switching support
- **Custom Color Palette**: Centralized color management
- **Typography System**: Consistent text styling across the app
- **Theme Provider**: Runtime theme switching

### Responsive Design
- **Responsive Configuration**: Automatic scaling for different screen sizes
- **Mobile & Tablet Support**: Separate reference sizes for optimal layouts
- **Responsive Extensions**: Easy-to-use scaling utilities
- **Orientation Handling**: Adaptive layouts for portrait/landscape

### Pre-built Services
- **Dio HTTP Client**: Complete networking setup with interceptors
- **Local Storage**: Secure storage implementation (flutter_secure_storage)
- **Logger Service**: Structured logging for debugging
- **Network Connectivity**: Real-time connectivity monitoring
- **Image Picker Service**: Camera and gallery integration
- **Push Notifications**: Firebase Cloud Messaging setup
- **Error Handling**: Centralized exception management

### UI Components Library
- **Animated Widgets**: Buttons, list items, fade-in, slide transitions
- **Custom Inputs**: Text fields, search fields with validation
- **Loaders**: Loading indicators and shimmer effects
- **Dialogs & Bottom Sheets**: Reusable modal components
- **Cards**: Customizable card widgets
- **Snackbars**: Pre-styled notification messages
- **Custom AppBar**: Flexible app bar implementations

### Utilities & Extensions
- **Context Extensions**: Easy access to theme, navigation, and more
- **String Extensions**: Validation, capitalization, and formatting
- **Widget Extensions**: Padding, margins, and other shortcuts
- **Responsive Extensions**: Scale dimensions proportionally
- **Form Validators**: Email, password, phone number validation
- **System Utils**: Status bar, orientation, and system UI controls

---

## Dependencies

### Core Dependencies
- **provider**: State management
- **get_it**: Dependency injection
- **go_router**: Declarative routing
- **dio**: HTTP client for API calls
- **flutter_secure_storage**: Secure local storage
- **connectivity_plus**: Network connectivity monitoring

### UI & Media
- **flutter_svg**: SVG rendering
- **cached_network_image**: Image caching
- **image_picker**: Camera and gallery access

### Firebase
- **firebase_core**: Firebase initialization
- **firebase_messaging**: Push notifications
- **flutter_local_notifications**: Local notification display
- **permission_handler**: Runtime permissions

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/itsmoeenahmad/flutter-clean-architecture-template.git
cd flutter-clean-architecture-template
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

### 4. Configure Firebase (Optional)

If you plan to use Firebase services:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

---

## Adding New Features

### Step 1: Create Feature Structure

```bash
lib/features/your_feature/
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
│   └── providers/
└── your_feature_di.dart
```

### Step 2: Implement Dependency Injection

Create `your_feature_di.dart`:

```dart
class YourFeatureDi {
  void init() {
    // Register data sources
    di.registerLazySingleton<YourRemoteDataSource>(
      () => YourRemoteDataSourceImpl(di()),
    );

    // Register repositories
    di.registerLazySingleton<YourRepository>(
      () => YourRepositoryImpl(di()),
    );

    // Register use cases
    di.registerLazySingleton(() => YourUseCase(di()));

    // Register providers (factories for screen-level)
    di.registerFactory(() => YourProvider(di()));
  }
}
```

### Step 3: Register in Global Container

Add to `lib/app/injection_container.dart`:

```dart
Future<void> initializeDependencies() async {
  // ...existing registrations...

  // Your Feature Dependencies
  YourFeatureDi().init();
}
```

### Step 4: Use in Presentation Layer

```dart
class YourScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di<YourProvider>(),
      child: const YourScreenView(),
    );
  }
}
```

---

## Best Practices

### Dependency Injection
- Use `registerFactory` for **screen-level providers** (new instance per request)
- Use `registerLazySingleton` for **repositories, use cases, and global services**
- Use `registerSingleton` only when immediate initialization is required

### Layer Separation
- **Domain Layer**: Pure Dart, no Flutter/external dependencies
- **Data Layer**: Can use external packages (Dio, HTTP), no Flutter UI
- **Presentation Layer**: Can depend on domain, uses use cases, not repositories directly

### State Management
- Keep business logic in **use cases**, not in providers
- Providers should only manage UI state and call use cases
- Use `notifyListeners()` to update UI after state changes

### Routing
- Define all route names in `route_names.dart`
- Use type-safe navigation with `context.go()` or `context.push()`
- Implement error pages for undefined routes

### Theme & Styling
- Never hardcode colors or text styles in widgets
- Use `context.colors` and `context.textTheme` extensions
- Add all colors to `app_colors.dart` and text styles to `app_text_style.dart`

### Responsive Design
- Use `context.responsive` extension for scaling
- Define reference sizes in `ResponsiveProvider` (main.dart)
- Test layouts on multiple screen sizes

### Error Handling
- Wrap API calls in try-catch blocks
- Use custom exceptions from `dio_exceptions.dart`
- Show user-friendly error messages via snackbars or dialogs

---

## Layer Responsibilities

### Domain Layer
**Purpose**: Business logic and contracts
**Contains**: Entities, Use Cases, Repository Interfaces
**Rules**:
- ❌ No Flutter dependencies
- ❌ No external packages (except core Dart)
- ✔ Pure business logic
- ✔ Framework-independent

### Data Layer
**Purpose**: Data fetching and persistence
**Contains**: Models, Data Sources, Repository Implementations
**Rules**:
- ❌ No Flutter UI code
- ❌ No dependency on presentation
- ✔ Can use external packages (Dio, HTTP)
- ✔ Implements domain contracts

### Presentation Layer
**Purpose**: UI and user interactions
**Contains**: Screens, Widgets, Providers (ChangeNotifier)
**Rules**:
- ✔ Can depend on domain layer
- ❌ Cannot depend on data layer directly
- ✔ Uses use cases to trigger logic
- ✔ Manages UI state only

---

## Available Services

### Logger Service
```dart
final logger = LoggerService(className: 'MyClass');
logger.info('Information message');
logger.error('Error message', error: e, stackTrace: st);
logger.warning('Warning message');
```

### Local Storage Service
```dart
final storage = di<LocalStorageService>();
await storage.write(key: 'token', value: 'abc123');
String? token = await storage.read(key: 'token');
await storage.delete(key: 'token');
```

### Network Service
```dart
final network = di<NetworkService>();
bool isConnected = await network.isConnected;
network.connectionStream.listen((isConnected) {
  // Handle connectivity changes
});
```

### Image Picker Service
```dart
final picker = di<ImagePickerService>();
final image = await picker.pickFromGallery();
final photo = await picker.pickFromCamera();
```

---

## Using Pre-built Widgets

### Custom Text Field
```dart
CustomTextField(
  controller: controller,
  label: 'Email',
  hint: 'Enter your email',
  validator: Validators.email,
)
```

### Custom Button
```dart
PrimaryButton(
  onPressed: () {},
  text: 'Submit',
  isLoading: isLoading,
)
```

### Custom Dialog
```dart
CustomDialog.show(
  context,
  title: 'Success',
  message: 'Operation completed',
)
```

### Shimmer Loader
```dart
ShimmerLoader(
  width: 200,
  height: 20,
)
```

---

## Notes

- All folder structures are intentionally included to maintain visibility
- The **auth feature** serves as a template with comprehensive README files in each layer
- Each service is pre-configured but can be extended or replaced
- The template follows Flutter best practices and official guidelines
- Responsive system supports both mobile and tablet devices
- All widgets are customizable and follow Material Design principles

---

## Contributing

Contributions are welcome! To maintain consistency:

1. Follow the Clean Architecture structure
2. Maintain layer separation rules
3. Add documentation for new features
4. Write meaningful commit messages
5. Test on multiple screen sizes
6. Update README if adding major features

---

## License

This project is open-source and available for use in personal and commercial projects.

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Provider Documentation](https://pub.dev/packages/provider)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

**Made with ❤️ for Flutter developers**
