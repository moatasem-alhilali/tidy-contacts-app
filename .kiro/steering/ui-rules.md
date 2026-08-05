# ✅ UI + Riverpod + Theme Extensions Rules (Final)

## 🎨 1) UI Development Rules

### 1.1 File Structure

* `screens/` → main screens
* `widgets/` → reusable UI components
* `widgets.dart` → barrel export file
* Split complex screens into separate widget files
* Screen max **300 lines** → break down into widgets

---

### 1.2 Import Order

1. Flutter
2. Third-party packages
3. Design system package
4. Core
5. Feature

* Remove unused imports
* Use alias only when name conflicts exist

---

### 1.3 Widget Structure

* Always prefer `const` constructors
* `super.key`
* Required params first, optional params second
* One widget = one responsibility

---

### 1.4 Formatting & Sizing

* Single-line for simple parameters
* Multi-line for complex widget trees
* Use design-system responsive extensions:

  * `16.w`, `16.h`, `16.r`, `16.sp`

---

### 1.5 State Management in UI (Riverpod)

* Use `ConsumerWidget` / `ConsumerStatefulWidget`
* Always handle `data/loading/error`
* Use dedicated widgets for empty & failure states

---

### 1.6 Navigation

* Use:

```dart
context.pushX(ExampleRoute())
```

(from context extensions)

* Always pass required parameters

---

### 1.7 User Feedback

* Use design system snackbars:

  * `showSuccessSnackbar`
  * `showErrorSnackbar`
  * `showWarningSnackbar`
* Never crash the UI on errors — always render failure states

---

### 1.8 Forms & Quick Actions

* Small actions/forms must use **Bottom Sheet**, not dialog
* Use existing sheets from:

```
lib/design-system-package/src/widgets/bottom_sheets
```

* Confirmation must use `showActionBottomSheet`

---

### 1.9 Buttons

* Always use:

```
lib/design-system-package/src/widgets/buttons/button_progress_state_widget.dart
```

* Do not reinvent loading buttons

---

### 1.10 Screen Skeleton & Helpers (Mandatory)

* Screen scaffold:

  * `AppScaffold` from `lib/design-system-package/src/widgets/scaffold/app_scaffold.dart`
* AppBar:

  * `BaseAppBarWidget` from `lib/src/core/widgets/base_app_bar_widget.dart`
* Empty:

  * `EmptyWidget`
* Failure:

  * `FailureWidget`

---

## 🎯 2) Theme & Design Tokens (Extensions Only)

### 2.1 Global Rule

**All UI styling must be consumed through BuildContext extensions only.**
No direct usage of theme classes in UI, no hardcoded colors, radii, spacing, or shadows.

✅ Allowed:

* `context.colors.primary`
* `context.corners.rb`
* `context.insets.xl`
* `context.shadows.medium`
* `context.spaces.md`
* `context.textStyles.titleMedium`

❌ Not allowed:

* `Color(0xFF...)`
* `Radius.circular(...)`
* `EdgeInsets.all(16)`
* `BoxShadow(...)`
* `TextStyle(...)`

---

### 2.2 Colors

Use:

```dart
context.colors.<name>
```

Examples:

* `context.colors.brandColor`
* `context.colors.primary`
* `context.colors.onPrimary`
* `context.colors.surface`
* `context.colors.onSurface`
* `context.colors.error`

---

### 2.3 Corners (Radii)

Use:

```dart
context.corners.<name>
```

Examples:

* `context.corners.rs`
* `context.corners.rm`
* `context.corners.rb`
* `context.corners.rc`
* `context.corners.rc360`

---

### 2.4 Insets (Spacing Values)

Use:

```dart
context.insets.<name>
```

Examples:

* `context.insets.sm`
* `context.insets.md`
* `context.insets.xl`

---

### 2.5 Spaces

Use:

```dart
context.spaces.<name>
```

Examples:

* `context.spaces.sm`
* `context.spaces.md`
* `context.spaces.bottom`

---

### 2.6 Shadows

Use:

```dart
context.shadows.<name>
```

Examples:

* `context.shadows.small`
* `context.shadows.medium`
* `context.shadows.large`

---

### 2.7 Text Styles

Use:

```dart
context.textStyles.<name>
```

Examples:

* `context.textStyles.titleMedium`
* `context.textStyles.labelMedium`
* `context.textStyles.bodyLarge`

Also:

* Use `TextWidget` (RTL + Arabic support)

---

### 2.8 UI Composition Rules (With Extensions)

* Padding uses `context.insets` + `.w/.h` where appropriate
* BorderRadius uses `context.corners`
* Colors always from `context.colors`
* Shadows always from `context.shadows`
* Text styles always from `context.textStyles`

Example patterns:

* `EdgeInsets.all(context.insets.xl.w)`
* `BorderRadius.all(context.corners.rb)`
* `color: context.colors.surface`
* `boxShadow: [context.shadows.small]`

---

## 🔧 3) Riverpod Provider Rules (Final)

### 3.1 Provider Types

Providers are strictly split into:

✅ **State Providers**

* Fetch data only
* **1 fetch function → 1 provider**
* AsyncNotifier returning `Future<T>`

✅ **Controller Providers**

* Mutations only (create/update/delete)
* Track request lifecycle via `RequestState`
* Refresh UI via invalidation only

---

### 3.2 Data Fetching Provider (Mandatory Pattern)

Every data-fetching provider must match this syntax:

```dart
@Riverpod(keepAlive: true)
class FeatureState extends _$FeatureState {
  @override
  Future<List<FeatureModel>> build(
    Map<String, dynamic> queries,
  ) async {
    final repository = ref.read(featureRepositoryProvider);
    final result = await repository.getItems(queries);

    if (result.isLeft) throw result.left;
    return result.right;
  }
}
```

Rules:

* `build()` returns `Future<T>`
* No manual loading state
* Errors are thrown
* Must be a family when queries/params exist

---

### 3.3 UI Consumption (Mandatory)

```dart
final state = ref.watch(featureStateProvider(_queries));
```

```dart
state.when(
  data: (items) => items.isEmpty
      ? _buildEmptyState(context)
      : _buildItemsList(context, ref, items),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stackTrace) => FailureWidget(
    subtitle: error.toString(),
    onPressed: () =>
        ref.invalidate(featureStateProvider(_queries)),
  ),
);
```

Rules:

* Retry uses `ref.invalidate(provider(params))`
* No custom state wrappers
* No manual refresh logic

---

### 3.4 Controller Provider (Mandatory Pattern)

All create/update/delete go into controller:

```dart
@Riverpod(keepAlive: true)
class FeatureController extends _$FeatureController {
  @override
  RequestState? build() => RequestState.initial;

  Future<Either<Failure, void>> createItem(
    FeatureRequest request,
  ) async {
    state = RequestState.loading;

    final result = await ref
        .read(featureRepositoryProvider)
        .createItem(request.toJson());

    state = RequestState.initial;

    if (result.isRight) {
      ref.invalidate(featureStateProvider);
    }

    return result;
  }

  bool isLoading() => state == RequestState.loading;
}
```

Rules:

* Controllers never fetch
* Controllers return `Either<Failure, void>`
* Controller state only for request lifecycle
* No UI mutation — only invalidation

---

### 3.5 Invalidation Rules (Critical)

After any successful mutation:

```dart
ref.invalidate(targetFetchProvider);
```

If fetch provider is parameterized:

```dart
ref.invalidate(featureStateProvider(_queries));
```

UI must never update fetched lists manually.

---

### 3.6 Error Handling

* Fetch providers: `throw`
* Controllers: `Either<Failure, void>`
* UI uses `fold` for controller results
* Error messages must be localized (Arabic)

---

### 3.7 Repository Access

* Always:

```dart
ref.read(featureRepositoryProvider)
```

* Never `ref.watch` inside async controller methods
* Repositories return `Either<Failure, T>`

---

### 3.8 Naming Conventions

* Fetch:

  * Class: `{Feature}State`
  * Provider: `{feature}StateProvider`
  * File: `{feature}_state.dart`
* Controller:

  * Class: `{Feature}Controller`
  * Provider: `{feature}ControllerProvider`
  * File: `{feature}_controller.dart`
* Avoid: `Manager`, `Handler`, `Provider`

---

### **3.X Request Model Rules (Mandatory)**

**Any data passed from Riverpod providers/controllers into repositories MUST be a dedicated Request Model object.**
This applies to:

* POST/PUT/PATCH form submissions
* GET requests with filters / pagination / sorting
* Any query parameters used to fetch data

✅ **Always pass typed request objects**
❌ Never pass raw `Map<String, dynamic>` or loose parameters directly into repository methods.

---

### **3.X.1 Why This Is Mandatory**

* Keeps API contracts stable and predictable
* Improves maintainability and readability
* Prevents scattered query keys across the codebase
* Enables strong typing, validation, and default values
* Makes requests reusable and testable

---

### **3.X.2 Required Pattern**

#### ✅ Riverpod State Provider (fetch)

Provider receives queries, converts them to a Request Model, then calls repository:

```dart
@Riverpod(keepAlive: true)
class FeatureState extends _$FeatureState {
  @override
  Future<List<FeatureModel>> build(Map<String, dynamic> queries) async {
    final request = FeatureListRequest.fromQueries(queries);

    final repository = ref.read(featureRepositoryProvider);
    final result = await repository.getItems(request);

    if (result.isLeft) throw result.left;
    return result.right;
  }
}
```

---

#### ✅ Controller Provider (create/update/delete)

Controllers must pass a Request Model object only:

```dart
Future<Either<Failure, void>> createItem(FeatureCreateRequest request) async {
  state = RequestState.loading;

  final result = await ref
      .read(featureRepositoryProvider)
      .createItem(request);

  state = RequestState.initial;

  if (result.isRight) {
    ref.invalidate(featureStateProvider);
  }

  return result;
}
```

---

### **3.X.3 Repository Contract Rule**

Repository methods must accept request objects, not maps:

✅ Correct:

```dart
Future<Either<Failure, List<FeatureModel>>> getItems(FeatureListRequest request);
Future<Either<Failure, void>> createItem(FeatureCreateRequest request);
Future<Either<Failure, void>> updateItem(String id, FeatureUpdateRequest request);
```

❌ Wrong:

```dart
Future<Either<Failure, List<FeatureModel>>> getItems(Map<String, dynamic> queries);
Future<Either<Failure, void>> createItem(Map<String, dynamic> body);
```

---

### **3.X.4 API Layer Rule (Retrofit / Dio)**

At the API class level, every request must use a request model:

✅ Correct:

```dart
@POST('/feature/create')
Future<ApiResponse<void>> create(@Body() FeatureCreateRequest request);

@GET('/feature/list')
Future<ApiResponse<List<FeatureModel>>> list(@Queries() FeatureListRequest request);
```

❌ Wrong:

```dart
Future<ApiResponse<void>> create(@Body() Map<String, dynamic> body);
Future<ApiResponse<List<FeatureModel>>> list(@Queries() Map<String, dynamic> queries);
```

---

### **3.X.5 Request Model Minimum Requirements**

Each request model must:

* Live under: `domain/request/`
* Be immutable (prefer `@freezed` or final fields)
* Support:

  * `toJson()` for body
  * `toQuery()` (or retrofit-friendly getters) for queries
  * `fromQueries(Map)` when provider receives a raw map
* Include defaults for pagination/sorting when needed

Example skeleton:

```dart
class FeatureListRequest {
  const FeatureListRequest({
    this.page = 1,
    this.limit = 20,
    this.search,
  });

  final int page;
  final int limit;
  final String? search;

  factory FeatureListRequest.fromQueries(Map<String, dynamic> q) {
    return FeatureListRequest(
      page: (q['page'] as int?) ?? 1,
      limit: (q['limit'] as int?) ?? 20,
      search: q['search'] as String?,
    );
  }

  Map<String, dynamic> toQuery() => {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
      };
}
```



### 3.9 Code Generation

Each provider file must include:

```dart
part 'file_name.g.dart';
```

Run:

```bash
dart run build_runner build
```

Never edit `.g.dart` manually.

---

## ✅ Final System Summary

* UI uses **extensions only**: `context.colors/corners/insets/spaces/shadows/textStyles`
* Fetch = AsyncNotifier provider returning `Future<T>`
* Actions = Controller provider returning `Either<Failure, void>`
* UI rendering via `AsyncValue.when`
* Refresh via `ref.invalidate()` only
* Max 300 lines per screen, split widgets aggressively
* Always use design system widgets for scaffolds, app bars, sheets, buttons, empty/failure states

---
