Iterable<Map<String, dynamic>> toIterableMap(dynamic data) {
  final result = <Map<String, dynamic>>[];
  try {
    if (data == null) return result;
    for (final item in data as Iterable) {
      result.add(
        (item as Map<dynamic, dynamic>).map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      );
    }
  } catch (e) {
    return result;
  }
  return result;
}

Map<String, dynamic> toMap(dynamic data) {
  var result = <String, dynamic>{};
  try {
    if (data == null) return result;
    result = (data as Map).map((key, value) => MapEntry(key.toString(), value));
  } catch (e) {
    return result;
  }
  return result;
}

Future<void> tryCatch(Future<void> Function() function) async {
  try {
    await function();
  } catch (e) {}
}

String dynamicToString(dynamic value) => value.toString();

// Helper method to force conversion to String for JSON parsing
String forceToString(dynamic value) {
  if (value == null) return '0';
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

double forceToDouble(dynamic value) {
  if (value == null) return 0;
  if (value is String) return double.tryParse(value) ?? 0.0;
  if (value is num) return value.toDouble();
  // If value is not String or num, try toString then parse, else return 0.0
  final str = value.toString();
  return double.tryParse(str) ?? 0.0;
}

int forceToInt(dynamic value) {
  if (value == null) return 0;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  // If value is not String or num, try toString then parse, else return 0
  final str = value.toString();
  return int.tryParse(str) ?? 0;
}

bool forceToBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) {
    final lowerValue = value.toLowerCase();
    return lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes';
  }
  if (value is num) return value != 0;
  return false;
}

DateTime? forceToDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }
  if (value is num) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    } catch (e) {
      return null;
    }
  }
  return null;
}
