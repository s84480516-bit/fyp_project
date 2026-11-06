# Data Layer (Auth)

The **data layer** is responsible for:
- Fetching data from remote or local sources
- Converting raw data into models
- Implementing repository contracts defined in the domain layer

## Responsibilities
- API calls
- DTO / Model definitions
- Repository implementations
- Data sources (remote / local)

## Contains
- `models/`
    - Request & response models
    - JSON serialization/deserialization
- `datasources/`
    - Remote data sources (API calls)
    - Local data sources (cache, secure storage)
- `repositories/`
    - Concrete implementations of domain repositories

## Rules
- ❌ Must NOT import Flutter UI code
- ❌ Must NOT depend on presentation layer
- ✔ Can depend on external packages (dio, http, etc.)
- ✔ Implements domain contracts

## Example Flow
UI → Provider → UseCase → Repository (interface)
→ RepositoryImpl → RemoteDataSource → API
