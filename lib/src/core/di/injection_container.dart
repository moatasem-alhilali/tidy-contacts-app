import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/core/helpers/sqlite_helper.dart';
import 'package:hive_manager/src/core/local/local_secure_storage.dart';
import 'package:hive_manager/src/core/local/local_storage.dart';
import 'package:hive_manager/src/core/network/dio/api_keys.dart';
import 'package:hive_manager/src/core/network/dio/dio.dart';
import 'package:hive_manager/src/core/network/dio/dio_failure_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();
@riverpod
LocalStorage localStorage(Ref ref) =>
    LocalStorage(preferences: ref.read(sharedPreferencesProvider));

@riverpod
LocalSecureStorage localSecureStorage(Ref ref) =>
    LocalSecureStorage(localStorage: ref.read(localStorageProvider));

@Riverpod(keepAlive: true)
Future<SQLiteHelper> sqliteHelper(Ref ref) async {
  final helper = SQLiteHelper();
  // Initialize the database once when the provider is created
  await helper.init();
  return helper;
}

@riverpod
NetworkInfo networkInfo(Ref ref) => NetworkInfoImpl();

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio();
  dio.options.sendTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.headers = {ApiKeys.accept: ApiKeys.applicationJson};
  dio.interceptors.addAll([
    DioFailureInterceptor(ref),
    DioAddLanguageInterceptor(ref),
    DioErrorRetryInterceptor(),
    // DioAddDebugInterceptor(),
  ]);
  // Add logging interceptor (only in debug mode)
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,

      responseBody: false,
      responseHeader: true,
      // logPrint: (object) {
      //   // Only log in debug mode
      //   if (kDebugMode) {
      //     // TODO: Replace with kDebugMode
      //     // _logger.debug(object.toString());
      //   }
      // },
    ),
  );

  return dio;
}
