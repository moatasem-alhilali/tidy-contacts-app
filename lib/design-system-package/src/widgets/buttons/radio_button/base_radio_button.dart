part of 'radio_button.dart';

abstract class BaseRadio<T> extends StatelessWidget {
  const BaseRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.activeColor,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context);
}
