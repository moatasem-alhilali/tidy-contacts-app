import 'dart:io';

///dart run lib/src/core/tools/create_feature.dart home
/// Feature Scaffolding Tool
///
/// This script generates a complete feature structure following our project architecture.
/// It creates the necessary directories and files for a new feature, including:
/// - Data layer (API, repositories, models, DI, enums)
/// - Domain layer (request models)
/// - Presentation layer (providers, screens, widgets)
/// - Dependency injection setup
/// - Routing configuration (optional)
///
/// Usage:
///   dart run lib/src/core/tools/create_feature.dart document
///
/// Example:
///   dart run lib/src/core/tools/create_feature.dart quote
///
/// The tool will prompt for additional options such as:
/// - Creating request models
/// - Adding enum files
/// - Setting up environment variables
/// - Generating routing configuration
/// - Creating documentation and screens

void main(List<String> args) async {
  if (args.isEmpty) {
    print('❌ Please provide a feature name.');
    return;
  }

  final rawName = args.first;
  final pascalName = _toPascalCase(rawName);
  final camelName = _toCamelCase(rawName);
  final snakeName = _toSnakeCase(rawName);
  final basePath = 'lib/src/features/$snakeName';

  // Check if feature already exists
  if (Directory(basePath).existsSync()) {
    final overwrite = _prompt('⚠️ Feature already exists. Overwrite? (y/n): ');
    if (overwrite.toLowerCase() != 'y') {
      print('⚠️ Operation canceled.');
      return;
    }
  }

  // Ask for optional files
  final requestWanted = _prompt(
    'Do you want to create request models? (y/n): ',
  );
  final enumWanted = _prompt('Do you want to create enums.dart? (y/n): ');
  final baseUrlKey = _prompt(
    'Enter Env key for baseUrl (leave blank to skip): ',
  );
  final addRoutes = _prompt('Do you want to create routes.dart file? (y/n): ');
  final docWanted = _prompt('Do you want to create documentation? (y/n): ');
  final widgetWanted = _prompt(
    'Do you want to create widget templates? (y/n): ',
  );
  final envVarsWanted = _prompt(
    'Do you want to add environment variables? (y/n): ',
  );
  final screenWanted = _prompt(
    'Do you want to create screen template? (y/n): ',
  );

  // If routes are requested, screen is automatically created
  final shouldCreateScreen =
      screenWanted.toLowerCase() == 'y' || addRoutes.toLowerCase() == 'y';

  final dirs = [
    '$basePath/data/api',
    '$basePath/data/di',
    '$basePath/data/enums',
    '$basePath/data/models',
    '$basePath/data/repositories',
    '$basePath/domain/request',
    '$basePath/presentation/providers',
    '$basePath/presentation/views/screens',
    '$basePath/presentation/views/widgets',
  ];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
    print('📁 Created: $dir');
  }

  await _writeFile(
    '$basePath/data/api/${snakeName}_api.dart',
    _apiTemplate(pascalName, snakeName),
  );
  await _writeFile(
    '$basePath/data/di/injection_container.dart',
    _diTemplate(pascalName, snakeName, baseUrlKey),
  );
  await _writeFile(
    '$basePath/data/models/${snakeName}_model.dart',
    _modelTemplate(pascalName, snakeName),
  );
  await _writeFile(
    '$basePath/data/repositories/${snakeName}_repository.dart',
    _repoTemplate(pascalName, snakeName),
  );
  await _writeFile(
    '$basePath/presentation/providers/${snakeName}_controller.dart',
    _providerTemplate(pascalName, snakeName),
  );
  await _writeFile(
    '$basePath/presentation/providers/${snakeName}_state.dart',
    _stateProviderTemplate(pascalName, snakeName),
  );

  if (requestWanted.toLowerCase() == 'y') {
    await _writeFile(
      '$basePath/domain/request/${snakeName}_request.dart',
      _requestTemplate(pascalName, snakeName),
    );
  }

  if (enumWanted.toLowerCase() == 'y') {
    await _writeFile(
      '$basePath/data/enums/enums.dart',
      _enumTemplate(pascalName),
    );
  }

  if (addRoutes.toLowerCase() == 'y') {
    // Create screen file first since routes depend on it
    await _writeFile(
      '$basePath/presentation/views/screens/${snakeName}_screen.dart',
      _screenTemplate(pascalName, snakeName),
    );

    await _writeFile(
      '$basePath/presentation/views/screens/routes.dart',
      _routesTemplate(pascalName, snakeName),
    );

    // Update feature aggregator routes
    // await _updateParentRoutes(pascalName, snakeName);
  }

  if (docWanted.toLowerCase() == 'y') {
    await _writeFile(
      '$basePath/README.md',
      _readmeTemplate(pascalName, snakeName),
    );
  }

  if (widgetWanted.toLowerCase() == 'y') {
    await _writeFile(
      '$basePath/presentation/views/widgets/${snakeName}_widget.dart',
      _widgetTemplate(pascalName, snakeName),
    );
  }

  if (envVarsWanted.toLowerCase() == 'y') {
    final envVarKeys = _prompt(
      'Enter environment variable keys (comma separated): ',
    );
    await _updateEnvFile(envVarKeys.split(','), snakeName);
  }

  if (shouldCreateScreen && addRoutes.toLowerCase() != 'y') {
    // Only create screen separately if routes weren't requested (to avoid duplication)
    await _writeFile(
      '$basePath/presentation/views/screens/${snakeName}_screen.dart',
      _screenTemplate(pascalName, snakeName),
    );
  }

  print('✅ Feature $snakeName scaffolded successfully in $basePath!');
}

String _prompt(String msg) {
  stdout.write(msg);
  return stdin.readLineSync() ?? '';
}

Future<void> _writeFile(String path, String content) async {
  try {
    final file = File(path);
    if (!file.existsSync()) {
      await file.create(recursive: true);
      await file.writeAsString(content);
      print('📝 Created: $path');
    } else {
      await file.writeAsString(content);
      print('🔄 Updated: $path');
    }
  } catch (e) {
    print('❌ Error writing to $path: $e');
  }
}

String _toPascalCase(String name) =>
    name.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();

String _toCamelCase(String name) {
  final pascal = _toPascalCase(name);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String _toSnakeCase(String name) => name
    .replaceAllMapped(
      RegExp('[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    )
    .replaceFirst(RegExp('^_'), '');

String _apiTemplate(String className, String fileName) =>
    '''
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';

part '${fileName}_api.g.dart';

@RestApi()
abstract class ${className}Api {
  factory ${className}Api(Dio dio, {required String baseUrl}) = _${className}Api;

  @GET('/$fileName')
  Future<${className}Model> getData();
  
  @GET('/$fileName/{id}')
  Future<${className}Model> getItem(@Path('id') String id);
  
  @POST('/$fileName')
  Future<void> createItem(@Body() Map<String, dynamic> request);
  
  @PUT('/$fileName/{id}')
  Future<void> updateItem(@Path('id') String id, @Body() Map<String, dynamic> request);
  
  @DELETE('/$fileName/{id}')
  Future<void> deleteItem(@Path('id') String id);
}
''';

String _diTemplate(String className, String fileName, String baseUrlKey) =>
    '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_manager/env/env.dart';
import 'package:hive_manager/src/core/di/injection_container.dart';
import 'package:hive_manager/src/features/$fileName/data/api/${fileName}_api.dart';
import 'package:hive_manager/src/features/$fileName/data/repositories/${fileName}_repository.dart';

part 'injection_container.g.dart';

@riverpod
${className}Api ${_toCamelCase(fileName)}Api(Ref ref) =>
    ${className}Api(ref.read(dioClientProvider), baseUrl: ${baseUrlKey.isNotEmpty ? 'Env.$baseUrlKey' : 'Env.BASE_URL'});

@riverpod
${className}Repository ${_toCamelCase(fileName)}Repository(Ref ref) =>
    ${className}RepositoryImp(ref.read(${_toCamelCase(fileName)}ApiProvider));
''';

String _modelTemplate(String className, String fileName) =>
    '''
import 'package:json_annotation/json_annotation.dart';

part '${fileName}_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ${className}Model {
  const ${className}Model({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ${className}Model.fromJson(Map<String, dynamic> json) => _\$${className}ModelFromJson(json);
  Map<String, dynamic> toJson() => _\$${className}ModelToJson(this);
}
''';

String _requestTemplate(String className, String fileName) =>
    '''
import 'package:json_annotation/json_annotation.dart';

part '${fileName}_request.g.dart';

@JsonSerializable(explicitToJson: true)
class ${className}Request {
  const ${className}Request({
    required this.name,
    this.description,
  });

  factory ${className}Request.fromJson(Map<String, dynamic> json) =>
      _\$${className}RequestFromJson(json);

  Map<String, dynamic> toJson() => _\$${className}RequestToJson(this);

  final String name;
  final String? description;
}
''';

String _enumTemplate(String className) =>
    '''
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ${className}Status {
  ACTIVE,
  INACTIVE,
  PENDING,
}
''';

String _repoTemplate(String className, String fileName) =>
    '''
import 'package:hive_manager/src/core/either/either.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/features/$fileName/data/api/${fileName}_api.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';

/// Repository contract for $className feature
abstract class ${className}Repository {
  /// Fetches data from the API
  Future<Either<Failure, ${className}Model>> getData();
  
  /// Creates a new item
  Future<Either<Failure, void>> createItem(Map<String, dynamic> request);
  
  /// Updates an existing item
  Future<Either<Failure, void>> updateItem(String id, Map<String, dynamic> request);
  
  /// Deletes an item by ID
  Future<Either<Failure, void>> deleteItem(String id);
}

/// Implementation of the $className repository
class ${className}RepositoryImp extends ${className}Repository {
  final ${className}Api _api;
  ${className}RepositoryImp(this._api);

  @override
  Future<Either<Failure, ${className}Model>> getData() async {
    return Either.tryFailure(() async {
      final result = await _api.getData();
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> createItem(Map<String, dynamic> request) async {
    return Either.tryFailure(() async {
      await _api.createItem(request);
    });
  }

  @override
  Future<Either<Failure, void>> updateItem(String id, Map<String, dynamic> request) async {
    return Either.tryFailure(() async {
      await _api.updateItem(id, request);
    });
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    return Either.tryFailure(() async {
      await _api.deleteItem(id);
    });
  }
}
''';

String _providerTemplate(String className, String fileName) =>
    '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_manager/src/core/either/either.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/features/$fileName/data/di/injection_container.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';
import 'package:hive_manager/src/features/$fileName/domain/request/${fileName}_request.dart';

part '${fileName}_controller.g.dart';

/// Comprehensive $fileName provider that coordinates all $fileName operations
/// This provider provides a unified interface for all $fileName-related functionality
@Riverpod(keepAlive: true)
class ${className}Controller extends _\$${className}Controller {
  @override
  ${className}Model? build() {
    return null;
  }

  /// Get $fileName data
  Future<Either<Failure, ${className}Model>> getData() async {
    final result = await ref.read(${_toCamelCase(fileName)}RepositoryProvider).getData();

    // Update local state if successful
    if (result.isRight) {
      state = result.right;
    }

    return result;
  }

  /// Refresh $fileName data
  Future<Either<Failure, ${className}Model>> refreshData() async {
    final result = await ref
        .read(${_toCamelCase(fileName)}RepositoryProvider)
        .getData();

    // Update local state if successful
    if (result.isRight) {
      state = result.right;
    }

    return result;
  }

  /// Create new item
  Future<Either<Failure, void>> createItem(${className}Request request) async {
    final result = await ref
        .read(${_toCamelCase(fileName)}RepositoryProvider)
        .createItem(request.toJson());

    // Refresh data if successful
    if (result.isRight) {
      await refreshData();
    }

    return result;
  }

  /// Update existing item
  Future<Either<Failure, void>> updateItem(String id, ${className}Request request) async {
    final result = await ref
        .read(${_toCamelCase(fileName)}RepositoryProvider)
        .updateItem(id, request.toJson());

    // Refresh data if successful
    if (result.isRight) {
      await refreshData();
    }

    return result;
  }

  /// Delete item
  Future<Either<Failure, void>> deleteItem(String id) async {
    final result = await ref
        .read(${_toCamelCase(fileName)}RepositoryProvider)
        .deleteItem(id);

    // Refresh data if successful
    if (result.isRight) {
      await refreshData();
    }

    return result;
  }
}
''';

String _stateProviderTemplate(String className, String fileName) =>
    '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';

part '${fileName}_state.g.dart';

/// State provider for $fileName data
@Riverpod(keepAlive: true)
class ${className}State extends _\$${className}State {
  @override
  ${className}Model? build() {
    return null;
  }

  /// Update the current state
  void updateState(${className}Model newState) {
    state = newState;
  }

  /// Clear the current state
  void clearState() {
    state = null;
  }
}
''';

String _routesTemplate(String className, String fileName) =>
    '''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '${fileName}_screen.dart';

export 'routes.gr.dart';

@AutoRouterConfig(
  generateForDir: ['lib/src/features/$fileName/presentation/views/screens'],
)
final class Routes extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/$fileName',
          page: ${className}Route.page,
          initial: true,
          meta: const {'breadcrumb': '$className'},
        ),
      ];

  static final routerKey = GlobalKey<AutoRouterState>();
}
''';

String _readmeTemplate(String className, String fileName) =>
    '''
# $className Feature

## Overview
This feature manages the $className functionality in the application.

## Structure
- **Data Layer**: API client, repositories, models, DI, enums
- **Domain Layer**: Request models
- **Presentation Layer**: Providers, screens, widgets

## Dependencies
- Riverpod for state management
- Retrofit for API calls
- Auto Route for navigation

## Usage
Example of using the $className feature:

```dart
// Load data using the provider
final data = ref.watch(${fileName}Provider);

// Display in a widget
if (data != null) {
  // Show data
} else {
  // Show loading or empty state
}
```
''';

String _widgetTemplate(String className, String fileName) =>
    '''
import 'package:flutter/material.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';

class ${className}Widget extends StatelessWidget {
  const ${className}Widget({
    super.key,
    required this.item,
    this.onTap,
  });

  final ${className}Model item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                Text(item.description!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
''';

String _screenTemplate(String className, String fileName) =>
    '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hive_manager/src/features/$fileName/presentation/providers/${fileName}_provider.dart';
import 'package:hive_manager/src/features/$fileName/data/models/${fileName}_model.dart';

@RoutePage()
class ${className}Screen extends ConsumerWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${fileName}Provider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('$className'),
      ),
      body: state != null 
        ? _Content(item: state)
        : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.item});

  final ${className}Model item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$className: \${item.name}'),
          if (item.description != null) ...[
            const SizedBox(height: 16),
            Text(item.description!),
          ],
        ],
      ),
    );
  }
}
''';

Future<void> _updateEnvFile(List<String> keys, String featureName) async {
  const envFilePath = 'lib/env/env.dart';
  final envFile = File(envFilePath);

  if (await envFile.exists()) {
    final content = await envFile.readAsString();

    // Add environment variables section for this feature
    final classEnd = content.lastIndexOf('}');
    if (classEnd != -1) {
      final keysSection =
          '''
  
  // $featureName feature variables
${keys.map((key) => "  static const String ${featureName.toUpperCase()}_$key = const String.fromEnvironment('${featureName.toUpperCase()}_$key');").join('\n')}
''';

      final updatedContent =
          content.substring(0, classEnd) +
          keysSection +
          content.substring(classEnd);
      await envFile.writeAsString(updatedContent);
      print('📝 Updated environment variables in: $envFilePath');
    }
  }
}

Future<void> _updateParentRoutes(String className, String fileName) async {
  const homeRoutesPath =
      'lib/src/features/home/presentation/views/screens/routes.dart';
  final homeRoutesFile = File(homeRoutesPath);

  if (await homeRoutesFile.exists()) {
    final content = await homeRoutesFile.readAsString();

    if (!content.contains(fileName)) {
      // Check if import section exists
      final importsEnd = content.indexOf('export');
      if (importsEnd != -1) {
        // Add import
        final newImport =
            "import 'package:hive_manager/src/features/$fileName/presentation/views/screens/routes.dart' as $fileName;\n";
        final firstPart = content.substring(0, importsEnd);
        final secondPart = content.substring(importsEnd);

        // Add route in child routes section
        final updatedContent = firstPart + newImport + secondPart;
        final routeLocation = updatedContent.indexOf('children: [');

        if (routeLocation != -1) {
          final routeInsertPos = updatedContent.indexOf('],', routeLocation);
          if (routeInsertPos != -1) {
            final newRoute = '            ...$fileName.Routes().routes,\n';
            final finalContent =
                updatedContent.substring(0, routeInsertPos) +
                newRoute +
                updatedContent.substring(routeInsertPos);

            await homeRoutesFile.writeAsString(finalContent);
            print('📝 Updated parent routes in: $homeRoutesPath');
          }
        }
      }
    }
  }
}

String _entityTemplate(String className) =>
    '''
/// Entity class for $className
class ${className}Entity {
  const ${className}Entity({
    this.id,
    required this.name,
    this.description,
  });

  final int? id;
  final String name;
  final String? description;
}
''';
