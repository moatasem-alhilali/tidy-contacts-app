part of 'divider.dart';

class DividerLineWidget extends StatelessWidget {
  const DividerLineWidget({super.key, this.padding});
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: context.insets.md),
      child: Divider(
        height: 1.h,
        color: context.colors.inactive,
      ),
    );
  }
}
