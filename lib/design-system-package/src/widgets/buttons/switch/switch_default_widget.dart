part of 'switch.dart';

class SwitchDefaultWidget extends StatelessWidget {
  const SwitchDefaultWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoSwitch(
        activeColor: context.mode(
          context.colors.onPrimaryContainer,
          context.colors.onInactive,
        ),
        trackColor: context.colors.inactive,
        value: value,
        thumbColor: value
            ? context.colors.white
            : context.mode(
                context.colors.primary,
                context.colors.onTertiaryContainer,
              ),
        onChanged: onChanged,
      ),
    );
  }
}
