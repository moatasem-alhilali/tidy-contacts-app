part of 'extensions.dart';

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  String get lastThreeDigits {
    final lastThreeDigits = substring(length - 3);
    final asterisks = '*' * lastThreeDigits.length;
    return '$lastThreeDigits$asterisks';
  }

  String? get toNullIfEmpty {
    return trim().isEmpty ? null : this;
  }

  String toThreeDecimalPlaces() {
    return this;
    // final doubleValue = double.tryParse(this); /// TODO
    // if (doubleValue == null) {
    //   return this;
    // }
    // return doubleValue.toStringAsFixed(3);
  }

  bool get isUrl => Uri.tryParse(this)?.scheme == 'http' ||
      Uri.tryParse(this)?.scheme == 'https';


  String get toAmountString {
    return double.tryParse(this)?.toStringAsFixed(2) ?? this;
  }

  bool get isDouble {
    return double.tryParse(this) != null;
  }

}

extension NullStringExtension on String? {
  String get toFormattedDate {
    if (this == null) {
      return '';
    }

    return DateFormat('MMMM dd, yyyy').format(DateTime.parse(this!));
  }

  String get formatZero {
    if (this?.trim().isEmpty ?? true) return '0.00';

    // Try parsing as a number
    final number = double.tryParse(this!.trim());

    // If parsing fails (not a number), return the original string
    if (number == null) return this!;

    // If it's zero, return "0.00"
    if (number == 0) return '0.00';

    // Format as a number with two decimal places
    return number.toStringAsFixed(2);
  }
}
