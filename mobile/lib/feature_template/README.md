# ForenShield Enterprise Feature Template

This directory establishes the official architectural standard for all new features in ForenShield. 
It strictly enforces **Clean Architecture**, **SOLID principles**, and **Riverpod State Management**.

## Folder Structure

```
feature_name/
├── data/
│   ├── datasource/        # Remote APIs and Local Caches
│   ├── models/            # DTOs (Data Transfer Objects), JSON Serialization
│   └── repository/        # Concrete implementation of domain interfaces
├── domain/
│   ├── entities/          # Pure Dart classes representing business models
│   ├── repository/        # Abstract interfaces for data contracts
│   └── usecases/          # Single-responsibility business actions
└── presentation/
    ├── pages/             # Stateful/Stateless widget entry points
    ├── providers/         # Riverpod StateNotifiers/Providers
    └── widgets/           # Dumb/reusable UI components for this feature
```

## Responsibility of Every Layer

1. **Presentation Layer**: 
   - Depends *only* on the Domain layer (via Providers).
   - Responsible for mapping `State` to UI.
   - Contains no business logic or API calls.
2. **Domain Layer**:
   - The core of the feature. Does not depend on Data or Presentation.
   - Contains raw business logic (`Entities`), data contracts (`Repository Interfaces`), and execution logic (`Use Cases`).
3. **Data Layer**:
   - Depends *only* on the Domain layer.
   - Responsible for fetching data (Remote/Local) and mapping it to/from JSON (`Models`) to Domain `Entities`.

## Data Flow

`UI Event (Button Tap)` 
→ `Riverpod Provider (FeatureNotifier)` 
→ `Domain UseCase (CreateFeatureUseCase)` 
→ `Domain Interface (FeatureRepository)` 
→ `Data Implementation (FeatureRepositoryImpl)` 
→ `DataSource (FeatureRemoteDataSource)` 
→ `API (Dio)`

## Dependency Rules

- **Presentation** can import `Domain` and `Core`.
- **Data** can import `Domain` and `Core`.
- **Domain** can *ONLY* import `Core` (and standard Dart libraries).
- Features **CANNOT** import files from other Features. If two features need to share code, it belongs in `core/`.

## Best Practices

- **Immutability:** Use `Equatable` for Models, Entities, and States.
- **Error Handling:** Never throw raw exceptions to the UI. The Data layer catches `DioException`, wraps them in `ApiException`, and returns them as `Result.failure(Failure)`.
- **Null Safety:** Avoid `!` operators. Use `?` and handle fallbacks gracefully.
- **Provider States:** Always have an `isLoading` and `errorMessage` property inside your State classes to correctly drive standard UI layouts (`AppLoadingState`, `AppErrorState`).

## Example Feature Implementation

To create a new feature (e.g., `investigations`):
1. Copy this `feature_template` folder.
2. Rename the folder to `investigations`.
3. Rename all `feature_*.dart` files to `investigation_*.dart`.
4. Replace `Feature` with `Investigation` in all class definitions.
5. Implement the actual API endpoints inside `investigation_remote_datasource.dart`.
