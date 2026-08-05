part of 'extensions.dart';

extension DateTimeExtensions on DateTime? {
  String? get toLongDateString {
    if (this == null) return null;
    return intl.DateFormat('MMMM dd, yyyy', 'en').format(this!);
  }

  String? get toShortDateString {
    if (this == null) return null;
    return intl.DateFormat('dd/MM/yyyy', 'en').format(this!);
  }

  String? get toTimestampDateString {
    if (this == null) return null;
    return this!.millisecondsSinceEpoch.toString();
  }

  String? get formatToIsoWithZ {
    if (this == null) return null;
    return intl.DateFormat('EEEE، d MMMM y، hh:mm a').format(this!.toUtc());
  }

  String get toDateString {
    if (this == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(this!.year, this!.month, this!.day);

    if (date == today) {
      return 'اليوم';
    } else if (date == yesterday) {
      return 'امس';
    } else {
      final formatter = intl.DateFormat('dd MMMM ,yyyy');
      return formatter.format(this!);
    }
  }

  String get toRelativeTimeString {
    if (this == null) return '';

    final now = DateTime.now();
    final difference = now.difference(this!);

    if (difference.inDays > 0) {
      final formatter = intl.DateFormat('hh:mm a');
      return formatter.format(this!);
    }

    if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ${difference.inMinutes} دقيقة';
    } else {
      return 'الان';
    }
  }

  String? get toShortDate {
    if (this == null) return null;
    return intl.DateFormat('yyyy-MM-dd', 'en').format(this!);
  }

  //refactor the naming
  String get dayNameWithTime {
    if (this == null) return '';
    //if today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(this!.year, this!.month, this!.day);
    final formatter = DateFormat('EEEE');
    final timeFormatter = DateFormat('hh:mm a');
    String dayName;
    final time = timeFormatter.format(this!);

    if (date == today) {
      dayName = 'today';
    } else if (date == yesterday) {
      dayName = 'yesterday';
    } else {
      dayName = formatter.format(this!);
    }
    return '$dayName , $time';
  }
}
