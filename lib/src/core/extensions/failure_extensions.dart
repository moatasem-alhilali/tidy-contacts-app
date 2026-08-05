part of 'extensions.dart';

extension FailureExtensions on Object {
  String get message {
    if (this is Failure) {
      return (this as Failure).message;
    }
    return LocaleKeys.internal_server_error.tr();
  }

  int get statusCode {
    if (this is Failure) {
      return (this as Failure).statusCode;
    }
    return -1;
  }

  FailureCode ? get code {
    if (this is Failure) {
      return (this as Failure).code;
    }
    return null;
  }
}
