part of 'layout_widgets.dart';

class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({
    required this.mobile,
    required this.desktop,
    super.key,
  });

  final Widget mobile;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    }
    return mobile;
  }
}
