import 'package:flutter/services.dart';

/// A [TextInputFormatter] that formats input text as a credit card expiry date (MM/YY).
/// This formatter is typically used for Visa, MasterCard, and other credit card types that use
/// the MM/YY format for expiry dates.
class CreditCardExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (newTextLength >= 3) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 2)}/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }

    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 4));
      if (newValue.selection.end >= 4) selectionIndex++;
    }

    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
