part of '../cards.dart';

/// An expandable card for financial services that mimics the UI shown in the design.
/// This component allows toggling between expanded and collapsed states.
class ExpandableFinancialServicesCard extends StatefulWidget {
  /// Creates an expandable card for financial services.
  ///
  /// The [title] parameter is required and specifies the title of the card.
  /// The [children] parameter is required and specifies the list of child widgets to display when expanded.
  /// The [initiallyExpanded] parameter determines whether the card is initially expanded.
  /// The [icon] parameter specifies the icon to display beside the title.
  const ExpandableFinancialServicesCard({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.icon,
    super.key,
  });

  /// The title of the card.
  final String title;

  /// The list of child widgets to display when expanded.
  final List<Widget> children;

  /// Whether the card is initially expanded.
  final bool initiallyExpanded;

  /// The icon to display beside the title.
  final String? icon;

  @override
  State<ExpandableFinancialServicesCard> createState() =>
      _ExpandableFinancialServicesCardState();
}

class _ExpandableFinancialServicesCardState
    extends State<ExpandableFinancialServicesCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(context.corners.rc),
          ),
          color: _isExpanded ? context.colors.secondary : null,
          onPressed: _toggleExpanded,
          elevation: 0,
          highlightElevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: context.insets.md,
            horizontal: context.insets.sm,
          ),
          child: Row(
            children: [
              // Optional icon
              if (widget.icon != null) ...[
                ButtonIconCircleWidget(
                  icon: widget.icon!,
                  iconSize: 20.h,
                  size: 44.h,
                  iconColor: _isExpanded ? context.colors.onPrimary : null,
                  isSvgNetwork: true,
                ),
                SizedBox(width: context.insets.lg),
              ],

              // Title
              Expanded(
                child: TextWidget(
                  widget.title,
                  style: context.textStyles.headlineXSmall.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
              ),

              // Chevron icon that rotates based on expanded state
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.colors.onSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.insets.sm),

        // Expandable content with improved animation including fade
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            height: _isExpanded ? null : 0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(context.corners.rb),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _isExpanded
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: context.insets.sm,
                        horizontal: context.insets.md,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(context.corners.rb),
                        color: context.colors.secondary,
                      ),
                      child: Column(
                        children: widget.children,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
