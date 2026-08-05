part of 'extensions.dart';

extension ConvertFromDynamic on dynamic {
  double get toDouble {
    if (this is double) {
      return this as double;
    } else if (this is int) {
      return (this as int).toDouble();
    } else if (this is String) {
      return double.tryParse(this as String) ?? 0.0;
    } else {
      return 0;
    }
  }

  int get toInt {
    if (this is double) {
      return (this as double).toInt();
    } else if (this is int) {
      return this as int;
    } else if (this is String) {
      return double.tryParse(this as String)?.toInt() ?? 0;
    } else {
      return 0;
    }
  }
}

extension NumberExtension on num? {
  num get toNum {
    if (this is double) {
      return this!;
    } else if (this is int) {
      return this!;
    } else {
      return 0.0;
    }
  }
}

extension DoubleExtension on double {

  String get toPrice {
    return intl.NumberFormat('#,##0.0').format(this);
  }

  String get toPriceWithTwoDecimal {
    return intl.NumberFormat('#,##0.00').format(this);
  }

  String get toPriceWithoutDecimal {
    return intl.NumberFormat('#,##0').format(this);
  }

  SizedBox get verticalSpace{
    return SizedBox(height: this);
  }

  SizedBox get horizontalSpace{
    return SizedBox(width: this);
  }
}


extension IntExtension on int {


  SizedBox get verticalSpace{
    return SizedBox(height: this.toDouble());
  }

  SizedBox get horizontalSpace{
    return SizedBox(width: this.toDouble());
  }
}


