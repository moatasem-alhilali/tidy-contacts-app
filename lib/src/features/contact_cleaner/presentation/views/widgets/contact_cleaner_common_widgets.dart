// Shared presentation primitives for the Contact Cleaner feature.
// All containers are built on adaptive_platform_ui so they render natively
// (Material on Android, Cupertino / iOS 26 on iOS) with a single, tidy style.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

/// A rounded surface card used as the base container across every tab.
class ContactCleanerPanel extends StatelessWidget {
  const ContactCleanerPanel({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      margin: margin,
      padding: padding ?? EdgeInsets.all(context.insets.md.w),
      color: color ?? context.colors.surface,
      borderRadius: BorderRadius.all(context.corners.rb),
      child: child,
    );
  }
}

/// A compact metric tile (label + big value) built on [AdaptiveCard].
class ContactCleanerStatTile extends StatelessWidget {
  const ContactCleanerStatTile({
    required this.title,
    required this.value,
    super.key,
    this.width,
    this.backgroundColor,
    this.valueColor,
  });

  final String title;
  final String value;
  final double? width;
  final Color? backgroundColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AdaptiveCard(
        color: backgroundColor ?? context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rb),
        padding: EdgeInsets.all(context.insets.md.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title,
              style: context.textStyles.labelLarge.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
            SizedBox(height: context.insets.sm.h),
            TextWidget(
              value,
              style: context.textStyles.headlineSmall.copyWith(
                color: valueColor ?? context.colors.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small pill/tag used to annotate cards.
class ContactCleanerTag extends StatelessWidget {
  const ContactCleanerTag({
    required this.label,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rc360),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.insets.sm.w,
          vertical: context.insets.sm.h,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: context.spaces.md, color: textColor),
              SizedBox(width: context.insets.sm.w),
            ],
            TextWidget(
              label,
              style: context.textStyles.labelMedium.copyWith(
                color: textColor ?? context.colors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A labelled read-only value block (direction aware for phone numbers).
class ContactCleanerLabeledValue extends StatelessWidget {
  const ContactCleanerLabeledValue({
    required this.label,
    required this.value,
    super.key,
    this.valueDirection = TextDirection.rtl,
    this.backgroundColor,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextDirection valueDirection;
  final Color? backgroundColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final resolvedValue = valueDirection == TextDirection.ltr
        ? '‎${value.trim()}‎'
        : value;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rm),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.insets.sm.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              label,
              style: context.textStyles.labelMedium.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
            SizedBox(height: context.insets.sm.h),
            Directionality(
              textDirection: valueDirection,
              child: TextWidget(
                resolvedValue,
                textDirection: valueDirection,
                textAlign: TextAlign.start,
                style: context.textStyles.bodyLarge.copyWith(
                  color: valueColor ?? context.colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
