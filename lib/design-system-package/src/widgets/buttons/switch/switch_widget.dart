part of 'switch.dart';

class SwitchWidget extends BaseSwitch {
  const SwitchWidget({
    required super.onChanged,
    required super.value,
    super.isActive,
    super.offColor,
    super.onColor,
    super.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) => baseSwitchBuild(context: context);
}
