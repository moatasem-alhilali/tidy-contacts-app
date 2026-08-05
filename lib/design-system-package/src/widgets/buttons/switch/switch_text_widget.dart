part of 'switch.dart';

class SwitchTextWidget extends BaseSwitch {
  SwitchTextWidget({
    required super.onChanged,
    required super.value,
    super.isActive,
    super.offColor,
    super.onColor,
    super.width,
    super.disableColor,
  });

  @override
  Widget build(BuildContext context) => baseSwitchBuild(
        context: context,
        content: Builder(
          builder: (context) {
            return TextWidget(
              value ? 'OK' : 'OO',
              style: context.textStyles.labelMedium?.copyWith(
                color:
                    value ? context.colors.primary : context.colors.onSecondary,
              ),
            );
          },
        ),
      );
}
