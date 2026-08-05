part of 'list_widgets.dart';

class ListVerticalWidget extends StatefulWidget {
  const ListVerticalWidget({
    required this.length,
    required this.onChanged,
    required this.builder,
    this.index,
    super.key,
  });

  final int length;
  final int? index;
  final ValueChanged<int>? onChanged;
  final Widget Function(int index) builder;

  @override
  State<ListVerticalWidget> createState() => _ListVerticalWidgetState();
}

class _ListVerticalWidgetState extends State<ListVerticalWidget> {
  int? selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.length; ++i) ...[
          InkWell(
            onTap: () => setState(() {
              if (null != widget.index) selectedIndex = i;
              widget.onChanged?.call(i);
            }),
            borderRadius: BorderRadius.all(context.corners.rc),
            child: BorderGradientAnimationWidget(
              radius: context.corners.rc,
              withBorder: selectedIndex != (i + 1),
              bottomBorder: selectedIndex != i,
              bottomBorderColor: const Color(0xFF636366),
              fixedBorder: false,
              child: widget.builder(i),
            ),
          ),
          SizedBox(height: context.insets.lg),
        ],
      ],
    );
  }
}
