part of 'layout_widgets.dart';

class PageTransitionSwitcherWidget extends StatelessWidget {
  const PageTransitionSwitcherWidget({
    required this.index,
    required this.children,
    this.alignment,
    this.child,
    super.key,
  });

  final int index;
  final List<Widget> children;
  final Widget? child;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: true,
      duration: const Duration(milliseconds: 800),
      layoutBuilder: (entries) => Stack(
        alignment: alignment ?? Alignment.center,
        children: entries,
      ),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          SharedAxisTransition(
        animation: primaryAnimation,
        fillColor: Colors.transparent,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      ),
      child: child ?? children[index],
    );
  }
}
