import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(String msg) => Fluttertoast.showToast(
  msg: msg,
  fontAsset: 'assets/fonts/noto_kufi/NotoKufiArabic-Regular.ttf',
  toastLength: Toast.LENGTH_SHORT,
);
