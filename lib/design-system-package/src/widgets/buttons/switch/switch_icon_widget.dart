part of 'switch.dart';

class SwitchIconWidget extends BaseSwitch {
  const SwitchIconWidget({
    required super.onChanged,
    required super.value,
    super.key,
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
        return const SizedBox();
        // return value
        //     ? Assets.icons.done.svg(color: context.colors.primary)
        //     : Assets.icons.close.svg(color: context.colors.onSecondary);
      },
    ),
  );
}
