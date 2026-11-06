# Auth Feature

This feature handles all authentication-related functionality such as:
- Login
- Register
- Logout
- Token management
- User session handling

The feature strictly follows **Clean Architecture** and is divided into:
- data
- domain
- presentation

Each layer has a single responsibility and depends only on layers below it.

ChangeNotifierProvider(
create: (_) => di<LoginProvider>(),
)
