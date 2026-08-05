import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.replaceAll(' ', ''),
      selection: newValue.selection,
    );
  }
}

class ThreeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
    List<String> words = trimmedText.split(' ');

    if (words.length > 3) {
      // Remove extra words
      words = words.sublist(0, 3);
      trimmedText = words.join(' ');
    }

    // Keep the selection at the end of the text
    int selectionIndex = newValue.selection.end;
    int newSelectionIndex =
        selectionIndex - (newValue.text.length - trimmedText.length);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

class OneWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
    List<String> words = trimmedText.split(' ');

    if (words.length > 1) {
      // Remove extra words
      words = words.sublist(0, 1);
      trimmedText = words.join(' ');
    }

    // Keep the selection at the end of the text
    int selectionIndex = newValue.selection.end;
    int newSelectionIndex =
        selectionIndex - (newValue.text.length - trimmedText.length);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

class LimitedWordsInputFormatter extends TextInputFormatter {
  final int count;
  LimitedWordsInputFormatter({
    this.count = 3,
  });
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
    List<String> words = trimmedText.split(' ');

    if (words.length > count) {
      // Remove extra words
      words = words.sublist(0, count);
      trimmedText = words.join(' ');
    }

    // Keep the selection at the end of the text
    int selectionIndex = newValue.selection.end;
    int newSelectionIndex =
        selectionIndex - (newValue.text.length - trimmedText.length);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
