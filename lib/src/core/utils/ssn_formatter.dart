import 'package:flutter/services.dart';

/// Custom SSN Input Formatter
class SNNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Remove any non-digit characters
    text = text.replaceAll(RegExp(r'\D'), '');

    // Apply SSN format (XXX-XX-XXXX)
    if (text.length > 3 && text.length <= 5) {
      text = '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length > 5) {
      text =
          '${text.substring(0, 3)}-${text.substring(3, 5)}-${text.substring(5, 9)}';
    }

    // Return the formatted text
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
