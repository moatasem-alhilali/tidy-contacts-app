part of '../cards.dart';

class ExpandTileBaseWidget extends StatefulWidget {
  const ExpandTileBaseWidget({
    this.leading,
    this.title,
    this.body,
    this.iconBeginTurn,
    this.iconEndTurn,
    this.borderSide,
    this.borderRadius,
    this.expandedColor,
    this.iconBegin,
    this.iconEnd,
    this.padding,
    this.color,
    super.key,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? body;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;
  final String? iconBegin;
  final String? iconEnd;
  final EdgeInsets? padding;
  final Color? color;
  /// The beginning of the icon turn.
  ///
  /// Defaults to 0.
  /// Start with right arrow set to 0.25
  final double? iconBeginTurn;

  /// The end of the icon turn.
  ///
  /// Defaults to 0.5.
  /// End with right arrow set to 0.75
  final double? iconEndTurn;

  final Color? expandedColor;

  @override
  State<ExpandTileBaseWidget> createState() => _ExpandTileBaseWidgetState();
}

class _ExpandTileBaseWidgetState extends State<ExpandTileBaseWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconTurns;
  late final ValueNotifier<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconTurns = Tween<double>(
      begin: widget.iconBeginTurn ?? 0, // Always start with down arrow
      end: widget.iconEndTurn ?? 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _isExpanded = ValueNotifier(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isExpanded.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    _isExpanded.value = !_isExpanded.value;
    if (_isExpanded.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              widget.borderSide ??
                  BorderSide(
                    color: context.colors.onSecondaryContainer,
                    width: 1.h,
                  ),
            ),
            color: isExpanded && widget.expandedColor != null
                ? widget.expandedColor
                : context.colors.primary,
            borderRadius:
                widget.borderRadius ?? BorderRadius.all(context.corners.rb),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.all(context.corners.rb),
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(context.insets.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (widget.leading != null)
                          widget.title != null
                              ? widget.leading!
                              : Expanded(child: widget.leading!),
                        SizedBox(width: context.spaces.sm),
                        if (widget.title != null)
                          Expanded(child: widget.title!),
                        if (widget.iconBegin != null && !isExpanded)
                          ImageSvgAsset(
                            widget.iconBegin!,
                            height: 12.h,
                            width: 12.h,
                            color: context.colors.onPrimaryContainer,
                          )
                        else if (widget.iconEnd != null && isExpanded)
                          ImageSvgAsset(
                            widget.iconEnd!,
                            height: 12.h,
                            width: 12.h,
                            color: context.colors.onPrimaryContainer,
                          )
                        else
                          RotationTransition(
                            turns: _iconTurns,
                            child: Icon(
                              Icons.expand_more,
                              color: context.colors.onSecondary,
                            ),
                          ),
                      ],
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOutCubic,
                      ),
                      child: widget.body ?? const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
