import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
// --- Firebase disabled (not used currently) ---
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// ------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/core/provider/auto_route_notifier.dart';

class DioFailureInterceptor extends Interceptor {
  DioFailureInterceptor(this.ref);

  final Ref ref;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final failure = Failure.fromJson(
        err.response?.data as Map<String, dynamic>,
      );
      ref.read(autoRouteProvider.notifier).setFailure(failure);
      // --- Firebase disabled (not used currently) ---
      // await FirebaseCrashlytics.instance.recordError(
      //   err,
      //   err.stackTrace,
      //   reason: err.response?.data,
      //   printDetails: false,
      // );
      // ------------------------------------------------
    } catch (_) {
    } finally {
      final statusCode = err.response?.statusCode ?? 0;
      //TODO: enhance
      if (statusCode < 500) {
        return handler.next(err);
      }
      // Clone data safely
      final originalData = err.response?.data;
      final newData = <String, dynamic>{};

      // Optionally update 'message' field
      if (statusCode >= 500) {
        newData['message'] = LocaleKeys.internal_server_error.tr();
      }

      final updatedError = err.copyWith(
        message: statusCode >= 500
            ? LocaleKeys.internal_server_error.tr()
            : err.message,
        response: Response(
          requestOptions: err.requestOptions,
          data: newData,
          statusCode: statusCode,
        ),
      );

      handler.next(updatedError);
      // if (F.appFlavor != Flavor.development) {

      // } else {
      //   handler.next(err);
      // }
    }
  }
}
