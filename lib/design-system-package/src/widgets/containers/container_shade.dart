part of 'containers.dart';

class ContainerShadeWidget extends StatelessWidget {
  const ContainerShadeWidget({
    this.backChild,
    this.child,
    this.color,
    this.withGradients = false,
    super.key,
  });

  final Color? color;

  final Widget? child;
  final Widget? backChild;
  final bool withGradients;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (backChild != null) backChild!,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.all(context.corners.rb),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: withGradients
                    ? null
                    : (color ?? context.colors.tent.withAlpha(50)),
                gradient: withGradients ? context.gradients.tent : null,
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
