part of '../snack_bar.dart';

class SnackBarWarningMessageWidget extends StatelessWidget {
  const SnackBarWarningMessageWidget({
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
      backgroundColor: context.colors.secondaryFixed,
      icon: Icon(Icons.error, color: context.colors.secondaryFixed),
    );
  }
}
