import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/core/enums/enums.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/core/utils/logger.dart';

typedef Lazy<T> = T Function();

sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;

  bool get isRight => this is Right<L, R>;

  L get left => this.fold<L>(
    (value) => value,
    (right) =>
        throw Exception('Illegal use. You should check isLeft before calling'),
  );

  R get right => this.fold<R>(
    (left) =>
        throw Exception('Illegal use. You should check isRight before calling'),
    (value) => value,
  );

  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  static Future<Either<L, R>> tryEither<L extends Object, R>(
    L Function(L l) onLeft,
    Future<dynamic> Function() onRight,
  ) async {
    try {
      final result = await onRight();
      return Right(result as R);
    } catch (e) {
      return Left(onLeft(e as L));
    }
  }

  static Future<Either<Failure, R>> tryFailure<R>(
    Future<R> Function() onRight,
  ) async {
    try {
      final result = await onRight();
      return Right(result);
    } catch (e, s) {
      logger.e(e.toString(), stackTrace: s);
      if (e is DioException) {
        dynamic responseData = e.response?.data;
        dynamic errorMessage = e.message ?? e.toString();
        FailureCode? error;
        final statusCode = e.response?.statusCode ?? 500;

        if (responseData != null) {
          if (responseData is String) {
            try {
              responseData = jsonDecode(responseData);
            } catch (_) {
              responseData = {'message': responseData};
            }
          }

          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message'] ?? errorMessage;
            error = responseData['code'] != null
                ? FailureCode.values.firstWhereOrNull(
                    (element) =>
                        element.name == responseData['code'].toString(),
                  )
                : null;
          } else {
            errorMessage = responseData.toString();
          }
        }

        return Left(
          Failure(
            statusCode,
            errorMessage.toString(),
            error ?? FailureCode.SEC_006,
          ),
        );
      }
      return Left(
        Failure(500, LocaleKeys.default_error.tr(), FailureCode.SEC_006),
      );
    }
  }

  @override
  bool operator ==(Object obj) {
    return this.fold(
      (left) => obj is Left && left == obj.value,
      (right) => obj is Right && right == obj.value,
    );
  }

  @override
  int get hashCode => fold((left) => left.hashCode, (right) => right.hashCode);
}

/// Used for "failure"
class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnL(value);
  }
}

/// Used for "success"
class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnR(value);
  }
}
