# Presentation Layer (Auth)

The **presentation layer** is responsible for:
- UI rendering
- User interactions
- State management

This layer uses **Provider (ChangeNotifier)** for state handling.

## Responsibilities
- Screens (screens)
- Widgets
- Providers (ChangeNotifiers)
- UI state & validation

## Contains
- `screens/`
    - Full screens (LoginPage, RegisterPage)
- `widgets/`
    - Reusable UI components
- `providers/`
    - ChangeNotifier classes (LoginProvider, AuthProvider)

## Rules
- ✔ Can depend on domain layer
- ❌ Must NOT depend on data layer directly
- ✔ Uses use cases to trigger business logic

## State Flow
User Action  
→ Provider  
→ UseCase  
→ Repository  
→ Result  
→ Provider updates UI