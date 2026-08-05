import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/gen/assets.gen.dart';

/// Production-grade expandable floating sheet:
/// - Collapsed: bottom pill only
/// - Expanded: body panel slides up + fades in
/// - Smooth animation (height/opacity/translate/blur)
class ExpandableSheetWidget extends StatefulWidget {
  const ExpandableSheetWidget({
    required this.items,
    required this.onTabSelected,
    required this.bodyBuilder,
    super.key,
    this.initialIndex = 0,
    this.bodyHeight = 600,
    this.autoCollapse = false,
    this.bottomBillBottomPadding = 30,
  });
  final List<ExpandableFloatingSheetItem> items;
  final ValueChanged<int> onTabSelected;

  /// Provide the expanded body content here (e.g. your menu/list).
  final Widget Function(BuildContext context, int selectedIndex) bodyBuilder;

  final int initialIndex;
  final double bodyHeight;
  final bool autoCollapse;
  final double bottomBillBottomPadding;

  @override
  State<ExpandableSheetWidget> createState() => _ExpandableSheetWidgetState();
}

class _ExpandableSheetWidgetState extends State<ExpandableSheetWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t; // 0..1
  late final Animation<double> _opacity;
  late final Animation<double> _slideUp;
  late final Animation<double> _blur;

  final _portalController = OverlayPortalController();

  int _selectedIndex = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, widget.items.length - 1);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 320),
    );

    _t = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // More organic feel
      reverseCurve: Curves.easeInCubic,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );

    /// translateY: from 60px down to 0 (more dramatic slide)
    _slideUp = Tween<double>(
      begin: 60,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    /// blur strength increases slightly as it expands (optional nice touch)
    _blur = Tween<double>(begin: 12, end: 20).animate(_t);

    // Show the overlay as soon as we're mounted
    _portalController.show();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _collapse() {
    if (!_isExpanded) return;
    HapticFeedback.selectionClick();
    setState(() => _isExpanded = false);
    _controller.reverse();
  }

  void _selectTab(int index) {
    if (index < 0 || index >= widget.items.length) return;

    HapticFeedback.mediumImpact();
    setState(() => _selectedIndex = index);
    widget.onTabSelected(index);

    if (widget.autoCollapse) {
      _collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (context) {
        // Bottom safe padding
        final bottomPad = MediaQuery.of(context).padding.bottom;

        return Stack(
          children: [
            // Optional: tap outside to close when expanded
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final v = _t.value;
                if (v == 0) return const SizedBox.shrink();
                return Positioned.fill(
                  child: IgnorePointer(
                    ignoring: v < 0.05,
                    child: GestureDetector(
                      onTap: _collapse,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5 * v,
                            sigmaY: 5 * v,
                          ),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.15 * v),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Body panel (expanded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final v = _t.value;
                  if (v == 0) return const SizedBox.shrink();

                  return GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! > 10) _collapse();
                    },
                    child: IgnorePointer(
                      ignoring: v < 0.8,
                      child: Transform.translate(
                        offset: Offset(0, _slideUp.value),
                        child: Opacity(
                          opacity: _opacity.value,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: 24.h + bottomPad,
                            ),
                            child: _ExpandedBody(
                              height: widget.bodyHeight.h,
                              onCollapse: _collapse,
                              child: widget.bodyBuilder(
                                context,
                                _selectedIndex,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom pill (always visible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: widget.bottomBillBottomPadding.h + bottomPad,
                  left: context.insets.lg,
                  right: context.insets.lg,
                  top: context.insets.lg,
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    // You can slightly adjust pill height when expanded if you want
                    final pillHeight = lerpDouble(70.h, 76.h, _t.value)!;

                    return _BottomPill(
                      height: pillHeight,
                      blurSigma: _blur.value,
                      items: widget.items,
                      selectedIndex: _selectedIndex,
                      onTabTap: _selectTab,
                      onToggle: _toggle,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}

/// ----------------------------
/// Models
/// ----------------------------
class ExpandableFloatingSheetItem {
  ExpandableFloatingSheetItem({required this.title, required this.assetPath});

  final String title;
  final String assetPath;
}

/// ----------------------------
/// Bottom pill implementation
/// ----------------------------
class _BottomPill extends StatelessWidget {
  const _BottomPill({
    required this.height,
    required this.blurSigma,
    required this.items,
    required this.selectedIndex,
    required this.onTabTap,
    required this.onToggle,
  });

  final double height;
  final double blurSigma;
  final List<ExpandableFloatingSheetItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTabTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: const Color(0xFF000000).withValues(alpha: 0.20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: context.colors.onSurface.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.insets.xl,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: context.spaces.sm),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      return _TabItem(
                        label: it.title,
                        assetPath: it.assetPath,
                        isSelected: i == selectedIndex,
                        onTap: () => onTabTap(i),
                      );
                    },
                  ),
                ),

                SizedBox(width: context.spaces.sm),

                Padding(
                  padding: EdgeInsetsDirectional.only(end: context.insets.sm),
                  child: _ExpandButton(onTap: onToggle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
        ),
      ),
      icon: CircleAvatar(
        radius: 30.r,
        backgroundColor: context.colors.brand10Color,
        child: CircleAvatar(
          radius: 26.r,
          backgroundColor: context.colors.onPrimary,
          child: ImageWidget(
            Assets.icons.maximizeColor.path,
            height: 20.h,
            width: 20.w,
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(vertical: context.insets.sm),
        padding: EdgeInsets.symmetric(
          horizontal: context.insets.mn,
          vertical: context.insets.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.brand10Color : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(
              assetPath,
              height: 22.h,
              width: 22.w,
              color: isSelected
                  ? context.colors.primary
                  : context.colors.onInactive,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 74.w, // keeps consistent like the mock
              child: TextWidget(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.textStyles.labelSmall.copyWith(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.onInactive,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------
/// Expanded body panel
/// ----------------------------
class _ExpandedBody extends StatelessWidget {
  const _ExpandedBody({
    required this.onCollapse,
    required this.child,
    required this.height,
  });

  final VoidCallback onCollapse;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: context.colors.onSurface.withValues(alpha: 0.06),
            ),
            boxShadow: [context.shadows.large],
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Drag Handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              _Header(onCollapse: onCollapse),
              Expanded(child: child),
              _Footer(onCollapse: onCollapse),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onCollapse});
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.insets.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                'ISO-Click',
                style: context.textStyles.headlineSmall.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: context.colors.brandColor,
                ),
              ),
              TextWidget(
                'ISO SYSTEMS PLATFORM',
                style: context.textStyles.labelSmall.copyWith(
                  color: context.colors.brandColor.withOpacity(0.7),
                  letterSpacing: 2,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _TopIconButton(
                assetPath: Assets.icons.maximize.path,
                onTap: onCollapse,
              ),
              SizedBox(width: context.spaces.sm),
              _TopIconButton(
                assetPath: Assets.icons.notificationBing.path,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ImageWidget(
        assetPath,
        height: 24.h,
        width: 24.w,
        color: context.colors.onSurface,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onCollapse});
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        bottom: 20.h,
        right: 20.w,
        top: 10.h,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: onCollapse,
          icon: ImageWidget(
            Assets.icons.minimizeColor.path,
            height: 18.h,
            width: 18.w,
          ),
          label: const Text('تصغير'),
          style: TextButton.styleFrom(
            backgroundColor: context.colors.surface,
            foregroundColor: context.colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          ),
        ),
      ),
    );
  }
}
