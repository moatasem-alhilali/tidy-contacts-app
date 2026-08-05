part of '../snack_bar.dart';

class SnackBarErrorMessageWidget extends StatelessWidget {
  const SnackBarErrorMessageWidget({
    required this.message,
    this.title,
    super.key,
  });

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SnackBarBaseMessageWidget(
      title: title,
      message: message,
      backgroundColor: context.colors.error,
      icon: Icon(Icons.error, color: context.colors.error),
    );
  }
}
