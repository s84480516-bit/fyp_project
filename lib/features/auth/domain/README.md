# Domain Layer (Auth)

The **domain layer** contains the business logic of the authentication feature.

This layer is **framework-independent** and does not know anything about:
- Flutter
- Provider
- UI
- API implementations

## Responsibilities
- Define business rules
- Declare repository contracts
- Hold use cases
- Handle entities and failures

## Contains
- `entities/`
    - Core business objects (e.g., User)
- `repositories/`
    - Abstract repository interfaces
- `usecases/`
    - Application-specific business actions (Login, Logout, etc.)

## Rules
- ❌ Must NOT depend on data or presentation layer
- ❌ Must NOT import Flutter
- ✔ Pure Dart only
- ✔ Depends only on abstractions

## Example
LoginUseCase depends on AuthRepository (interface),
not on its implementation.
