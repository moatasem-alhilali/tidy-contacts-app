part of 'bottom_sheet.dart';

/// Enhanced navigation item with more customization options
class EnhancedNavigationItem {
  const EnhancedNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
    this.badgeColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? badge;
  final Color? badgeColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
}

/// Enhanced animated bottom navigation bar with advanced animations and effects
class EnhancedBottomNavigationBar extends StatefulWidget {
  const EnhancedBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showLabels = true,
    this.type = NavigationBarType.floating,
    super.key,
  });

  final List<EnhancedNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Duration animationDuration;
  final bool showLabels;
  final NavigationBarType type;

  @override
  State<EnhancedBottomNavigationBar> createState() =>
      _EnhancedBottomNavigationBarState();
}

class _EnhancedBottomNavigationBarState
    extends State<EnhancedBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _slideController;
  late Animation<double> _rippleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _slideController.forward();
  }

  @override
  void didUpdateWidget(EnhancedBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: widget.type == NavigationBarType.floating ? 100.h : 70.h,
        margin: widget.type == NavigationBarType.floating
            ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: widget.type == NavigationBarType.floating
              ? BorderRadius.circular(24.r)
              : null,
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
            if (widget.type == NavigationBarType.floating)
              BoxShadow(
                color: context.colors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return Expanded(
                child: _EnhancedNavigationItemWidget(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => widget.onTap(index),
                  animationDuration: widget.animationDuration,
                  showLabel: widget.showLabels,
                  rippleAnimation: _rippleAnimation,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Enhanced individual navigation item widget with advanced animations
class _EnhancedNavigationItemWidget extends StatefulWidget {
  const _EnhancedNavigationItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.animationDuration,
    required this.showLabel,
    required this.rippleAnimation,
  });

  final EnhancedNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDuration;
  final bool showLabel;
  final Animation<double> rippleAnimation;

  @override
  State<_EnhancedNavigationItemWidget> createState() =>
      _EnhancedNavigationItemWidgetState();
}

class _EnhancedNavigationItemWidgetState
    extends State<_EnhancedNavigationItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_EnhancedNavigationItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      _bounceController.forward();
      _glowController.forward().then((_) {
        _glowController.reverse();
      });
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _bounceController.reverse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container with enhanced animations
            AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimation,
                _bounceAnimation,
                _glowAnimation,
                widget.rippleAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? (widget.item.selectedBackgroundColor ??
                                context.colors.primary)
                          : (widget.item.backgroundColor ?? Colors.transparent),
                      borderRadius: BorderRadius.circular(16.r),
                      border: widget.isSelected
                          ? null
                          : Border.all(
                              color: context.colors.outline.withOpacity(0.2),
                              width: 1,
                            ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color:
                                    (widget.item.selectedBackgroundColor ??
                                            context.colors.primary)
                                        .withOpacity(
                                          0.3 * _glowAnimation.value,
                                        ),
                                blurRadius: 8 * _glowAnimation.value,
                                spreadRadius: 2 * _glowAnimation.value,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // Ripple effect
                        if (widget.isSelected)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: widget.rippleAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: RipplePainter(
                                    progress: widget.rippleAnimation.value,
                                    color: context.colors.primary.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        // Icon
                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              widget.isSelected
                                  ? widget.item.selectedIcon
                                  : widget.item.icon,
                              key: ValueKey(widget.isSelected),
                              color: widget.isSelected
                                  ? context.colors.onPrimary
                                  : context.colors.onSurfaceVariant,
                              size: 24.w,
                            ),
                          ),
                        ),
                        // Badge indicator with animation
                        if (widget.item.badge != null)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _bounceAnimation.value,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          widget.item.badgeColor ??
                                          context.colors.error,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (widget.item.badgeColor ??
                                                      context.colors.error)
                                                  .withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16.w,
                                      minHeight: 16.h,
                                    ),
                                    child: Text(
                                      widget.item.badge!,
                                      style: context.textStyles.labelSmall
                                          .copyWith(
                                            color: context.colors.onError,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
            // Label with enhanced animation
            if (widget.showLabel)
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: context.textStyles.labelSmall.copyWith(
                  color: widget.isSelected
                      ? context.colors.primary
                      : context.colors.onSurfaceVariant,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for ripple effect
class RipplePainter extends CustomPainter {
  const RipplePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Navigation bar type enum
enum NavigationBarType { floating, fixed }
