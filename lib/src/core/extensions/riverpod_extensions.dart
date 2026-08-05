part of 'extensions.dart';

extension RiverpodExtensions<T> on AsyncValue<T> {
  T? get data => hasValue ? value : null;
}
