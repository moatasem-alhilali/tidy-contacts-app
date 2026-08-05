part of 'app_bar.dart';

class AppBarBaseWidget extends StatelessWidget {
  const AppBarBaseWidget({
    this.leading,
    this.trailing,
    this.middle,
    this.centerMiddle = true,
    super.key,
  });

  final Widget? leading;

  final Widget? middle;

  final Widget? trailing;
  final bool centerMiddle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: NavigationToolbar(
        leading: leading,
        middle: middle,
        trailing: trailing,
        centerMiddle: centerMiddle,
      ),
    );
  }
}
