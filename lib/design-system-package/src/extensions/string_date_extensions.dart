part of 'extensions.dart';

extension StringDateExtensions on String {
  /// Formats a timestamp string to a readable date string
  /// Handles DateTime strings and other timestamp formats
  String get toFormattedDate {
    if (isEmpty) return '';

    try {
      // Try to parse as DateTime
      final dateTime = DateTime.parse(this);
      return dateTime.dayNameWithTime;
    } catch (e) {
      // If parsing fails, return the original string
      return this;
    }
  }
}

extension NullableStringDateExtensions on String? {
  /// Formats a nullable timestamp string to a readable date string
  /// Handles DateTime strings and other timestamp formats
  String get toFormattedDate {
    if (this == null || this!.isEmpty) return '';

    try {
      // Try to parse as DateTime
      final dateTime = DateTime.parse(this!);
      return dateTime.dayNameWithTime;
    } catch (e) {
      // If parsing fails, return the original string
      return this!;
    }
  }
}
