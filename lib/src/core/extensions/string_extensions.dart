part of 'extensions.dart';

extension StringExtensions on String {
   Color parseColor() {
    if (isEmpty) {
      return Colors.grey;
    }

    try {
      // Remove # if present
      var hex = startsWith('#') ? substring(1) : this;

      // Handle different hex formats
      if (hex.length == 3) {
        hex = hex.split('').map((char) => char + char).join();
      }

      if (hex.length == 6) {
        hex = 'FF$hex'; // Add alpha channel
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
