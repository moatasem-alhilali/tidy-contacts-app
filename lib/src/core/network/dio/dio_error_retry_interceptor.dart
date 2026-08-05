part of 'dio.dart';

class DioErrorRetryInterceptor extends Interceptor {
  DioErrorRetryInterceptor({
    this.retryCount = 3,
    this.retryOnStatusCodes = const [
      500,
      502,
      503,
      520,
      520,
      521,
      522,
      523,
      524,
      525,
      526,
      530
    ],
  });

  final int retryCount;
  final List<int> retryOnStatusCodes;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    // Only retry for specified status codes and idempotent methods
    final shouldRetry = retryOnStatusCodes.contains(statusCode) &&
        _isIdempotentRequest(err.requestOptions);

    if (!shouldRetry) {
      return handler.next(err);
    }

    var attempt = 0;

    while (attempt < retryCount) {
      try {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));

        // Clone request options
        final options = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          responseType: err.requestOptions.responseType,
          contentType: err.requestOptions.contentType,
          followRedirects: err.requestOptions.followRedirects,
          validateStatus: err.requestOptions.validateStatus,
          receiveDataWhenStatusError:
              err.requestOptions.receiveDataWhenStatusError,
          extra: err.requestOptions.extra,
        );

        final response = await Dio().request(
          '${err.requestOptions.baseUrl}${err.requestOptions.path}',
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: options,
          cancelToken: err.requestOptions.cancelToken,
          onSendProgress: err.requestOptions.onSendProgress,
          onReceiveProgress: err.requestOptions.onReceiveProgress,
        );

        return handler.resolve(response);
      } catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _isIdempotentRequest(RequestOptions request) {
    // Typically safe to retry GET, HEAD, PUT, DELETE
    return ['POST', 'GET', 'HEAD', 'PUT', 'DELETE']
        .contains(request.method.toUpperCase());
  }
}
