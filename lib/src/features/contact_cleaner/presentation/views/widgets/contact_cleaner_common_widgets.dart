// Shared presentation kit for the Contact Cleaner feature.
// Fully built on adaptive_platform_ui + the standard Flutter ThemeData
// (no design-system dependency), so every surface renders natively and
// consistently in light/dark.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

// Consistent spacing scale used across the whole feature.
const double kGapXs = 4;
const double kGapSm = 8;
const double kGapMd = 12;
const double kGapLg = 16;
const double kGapXl = 24;
const double kScreenPad = 16;

const BorderRadius kRadiusCard = BorderRadius.all(Radius.circular(18));
const BorderRadius kRadiusTile = BorderRadius.all(Radius.circular(12));
const BorderRadius kRadiusPill = BorderRadius.all(Radius.circular(999));

/// A rounded surface card — the base container across every tab.
class ContactCleanerPanel extends StatelessWidget {
  const ContactCleanerPanel({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(kScreenPad),
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: kRadiusCard,
      child: child,
    );
  }
}

/// A compact metric tile (label + big value).
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    return SizedBox(
      width: width,
      child: AdaptiveCard(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: kRadiusCard,
        padding: const EdgeInsets.all(kScreenPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: kGapSm),
            Text(
              value,
              style: tt.headlineSmall?.copyWith(
                color: valueColor ?? cs.onSurface,
                fontWeight: FontWeight.w700,
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color fg = textColor ?? cs.onSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: kRadiusPill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kGapMd, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: kGapXs),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

/// A labelled read-only value block (direction-aware for phone numbers).
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final String resolvedValue = valueDirection == TextDirection.ltr
        ? '‎${value.trim()}‎'
        : value;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: kRadiusTile,
      ),
      child: Padding(
        padding: const EdgeInsets.all(kGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: kGapXs),
            Directionality(
              textDirection: valueDirection,
              child: Text(
                resolvedValue,
                textDirection: valueDirection,
                textAlign: TextAlign.start,
                style: tt.bodyLarge?.copyWith(
                  color: valueColor ?? cs.onSurface,
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

/// Adaptive empty-state placeholder.
class ContactCleanerEmptyState extends StatelessWidget {
  const ContactCleanerEmptyState({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kGapXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: kGapMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: kGapSm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Adaptive error / call-to-action state (icon + message + AdaptiveButton).
class ContactCleanerFailureState extends StatelessWidget {
  const ContactCleanerFailureState({
    required this.title,
    required this.buttonText,
    required this.onPressed,
    super.key,
    this.subtitle,
    this.icon = Icons.error_outline,
  });

  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kGapXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: cs.error),
            const SizedBox(height: kGapMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: kGapSm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: kGapLg),
            AdaptiveButton(onPressed: onPressed, label: buttonText),
          ],
        ),
      ),
    );
  }
}
