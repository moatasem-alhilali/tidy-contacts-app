part of 'extensions.dart';

extension NumExtensions on num {
  double get h {
    return flutter_screenutil.ScreenUtil().setHeight(this);
  }

  double get w {
    return flutter_screenutil.ScreenUtil().setWidth(this);
  }

  double get sp {
    return flutter_screenutil.ScreenUtil().setSp(this);
  }

  double get r {
    return flutter_screenutil.ScreenUtil().radius(this);
  }

  String get formatBytes {
    if (this <= 0) return '0 Bytes';
    const suffixes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(this) / log(1024)).floor();
    return '${(this / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
