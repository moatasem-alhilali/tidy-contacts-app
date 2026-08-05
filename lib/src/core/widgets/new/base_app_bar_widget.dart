import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

class BaseAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBarWidget({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = false,
    this.elevation = 0,
    this.bottom,
    this.preferredSizeHeight,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double elevation;
  final double? preferredSizeHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.colors.background),
      child: AppBar(
        toolbarHeight: _resolvedHeight,
        scrolledUnderElevation: 0,
        surfaceTintColor: context.colors.surface,
        title: Column(
          crossAxisAlignment: centerTitle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: !centerTitle
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            TextWidget(
              title,
              style: context.textStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 2.h),
              TextWidget(
                subtitle,
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: elevation,
        centerTitle: centerTitle,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBackButton) _buildBackButton(context),
            if (leading != null) leading!,
          ],
        ),
        actions: actions,
        bottom: bottom,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.brandColor.withValues(alpha: 0.16),
                context.colors.brand10Color.withValues(alpha: 0.72),
                context.colors.surface,
              ],
            ),
            boxShadow: <BoxShadow>[context.shadows.medium],
            borderRadius: BorderRadius.only(
              bottomLeft: context.corners.rb,
              bottomRight: context.corners.rb,
            ),
            border: Border(
              bottom: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rm),
          side: BorderSide(
            color: context.colors.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      icon: Icon(Icons.arrow_back_ios, color: context.colors.onSurface),
      onPressed: onBackPressed ?? () => context.router.pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_resolvedHeight);

  double get _resolvedHeight =>
      preferredSizeHeight ?? (subtitle != null ? 82.h : 66.h);
}
