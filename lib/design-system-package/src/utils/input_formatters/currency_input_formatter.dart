part of 'input_formatters.dart';

class PriceInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the input is empty, return as is
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove non-numeric characters from the input
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the input with commas
    final formattedText = _formatter.format(int.parse(newText));

    // Return the updated value
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CombinedPriceInputFormatter extends TextInputFormatter {
  CombinedPriceInputFormatter({this.currencySymbol = ''});

  final String currencySymbol;
  final RegExp _regex = RegExp(r'^\d{0,6}([.]\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    text = text.replaceAll(currencySymbol, '').trim();

    // Convert Arabic digits to English
    text = _convertArabicToEnglish(text);

    // Prevent input if it doesn’t match the regex
    if (!_regex.hasMatch(text)) {
      return oldValue;
    }

    // Remove leading zeros correctly
    text = _removeLeadingZero(text);

    final formattedText = '$currencySymbol$text';

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  /// Converts Arabic numerals to English
  String _convertArabicToEnglish(String input) {
    const arabicToEnglishMap = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    return input
        .split('')
        .map((char) => arabicToEnglishMap[char] ?? char)
        .join();
  }

  /// Removes unnecessary leading zeros, but keeps "0.x" valid
  String _removeLeadingZero(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      input = input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}
