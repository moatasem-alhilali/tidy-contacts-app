part of 'tabs.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({
    required this.items,
    required this.value,
    required this.onChanged,
    this.padding,
    this.backgroundColor,
    this.thumbColor,
    this.radius,
    super.key,
  });

  final int value;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? thumbColor;
  final Radius? radius;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  late int index;

  @override
  void initState() {
    index = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    index = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(widget.radius ?? context.corners.rm),
      child: ColoredBox(
        color: widget.backgroundColor ?? context.colors.tertiaryContainer,
        child: CupertinoSlidingSegmentedControl(
          thumbColor: widget.thumbColor ?? context.colors.primary,
          backgroundColor:
              widget.backgroundColor ?? context.colors.tertiaryContainer,
          onValueChanged: (value) => setState(() {
            if (value == null) return;
            index = value;
            widget.onChanged(index);
          }),
          padding: widget.padding ?? EdgeInsets.all(context.insets.md),
          groupValue: index,
          children: {
            for (var i = 0; i < widget.items.length; ++i)
              i: TextWidget(
                widget.items[i],
                style: context.textStyles.labelLarge?.copyWith(
                  color: context.colors.onPrimaryContainer,
                ),
              ),
          },
        ),
      ),
    );
  }
}
