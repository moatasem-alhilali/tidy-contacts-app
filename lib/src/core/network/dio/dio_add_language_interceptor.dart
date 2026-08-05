part of 'dio.dart';

class DioAddLanguageInterceptor extends Interceptor {
  DioAddLanguageInterceptor(this.ref);

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _addTokenIfNeeded(options, handler);
  }

  Future<void> _addTokenIfNeeded(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final language = ref.read(languageStateProvider);
      options.headers[ApiKeys.acceptLanguage] =
           language;
    } catch (_) {}
    handler.next(options);
  }
}
