part of '../snack_bar.dart';

class SnackBarSuccessMessageWidget extends StatelessWidget {
  const SnackBarSuccessMessageWidget({
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
      backgroundColor: context.colors.primaryFixed,
      icon: Icon(Icons.check_circle_outline, color: context.colors.primaryFixed),
    );
  }
}
