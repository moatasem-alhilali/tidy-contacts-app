part of 'extensions.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the first element that satisfies the given index.
  T? elementAtOrNull(int? index) {
    if (index == null || index < 0) return null;
    return index < length ? elementAt(index) : null;
  }

  /// Returns the index of the first element that satisfies the given test.
  int? indexWhereOrNull(bool Function(T element) test) {
    for (var i = 0; i < length; i++) {
      if (test(elementAt(i))) return i;
    }
    return null;
  }
}
