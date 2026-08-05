// Distinct design primitives for the Contact Cleaner.
// Each section of the app composes a DIFFERENT primitive from here so no two
// sections share the same visual treatment, while the palette / radii stay
// consistent (organized, not random).

import 'dart:math' as math;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

// ------------------------------------------------------------------ tokens
const double kGapXs = 4;
const double kGapSm = 8;
const double kGapMd = 12;
const double kGapLg = 16;
const double kGapXl = 24;
const double kScreenPad = 16;

const BorderRadius kRadiusHero = BorderRadius.only(
  bottomLeft: Radius.circular(28),
  bottomRight: Radius.circular(28),
);
const BorderRadius kRadiusCard = BorderRadius.all(Radius.circular(20));
const BorderRadius kRadiusTile = BorderRadius.all(Radius.circular(14));
const BorderRadius kRadiusPill = BorderRadius.all(Radius.circular(999));

// ============================================================ HERO (header)
/// A full-bleed gradient hero band. Used only by the header — a bold,
/// image-like banner that is nothing like the flat cards below it.
class HeroBand extends StatelessWidget {
  const HeroBand({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: kRadiusHero,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, Color.lerp(cs.primary, cs.tertiary, 0.55)!],
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(kGapLg),
        child: child,
      ),
    );
  }
}

/// A round action inside the hero: glassy circle + label underneath.
class HeroAction extends StatelessWidget {
  const HeroAction({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.enabled = true,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final Color onHero = Colors.white;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        borderRadius: kRadiusPill,
        onTap: enabled && !busy ? onTap : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: onHero.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: onHero.withValues(alpha: 0.35)),
              ),
              child: busy
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: onHero, size: 24),
            ),
            const SizedBox(height: kGapSm),
            SizedBox(
              height: 30,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onHero,
                  fontSize: 11,
                  height: 1.15,
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

// ============================================================= SCORE (overview)
/// A circular gauge used once, at the top of the overview — a dashboard hero
/// that is completely different from the flat panels.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    required this.percent,
    required this.centerValue,
    required this.caption,
    super.key,
    this.size = 132,
  });

  final double percent; // 0..1
  final String centerValue;
  final String caption;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Color ring = Color.lerp(cs.error, cs.primary, percent.clamp(0, 1))!;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          percent: percent.clamp(0, 1),
          color: ring,
          track: cs.surfaceContainerHighest,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerValue,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              Text(
                caption,
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.percent,
    required this.color,
    required this.track,
  });

  final double percent;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const double stroke = 12;
    final Offset center = size.center(Offset.zero);
    final double radius = (size.width - stroke) / 2;
    final Paint trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}

/// A compact metric chip used in a horizontal strip (overview) — small,
/// colourful, scrollable; unlike the big 2-column stat cards used before.
class MetricChip extends StatelessWidget {
  const MetricChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Container(
      width: 120,
      padding: const EdgeInsets.all(kGapMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: kRadiusTile,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: kGapSm),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ============================================================ TIMELINE (issues)
/// A left-rail timeline row — issues read like a feed, not like cards.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    required this.dotColor,
    required this.child,
    super.key,
    this.isLast = false,
  });

  final Color dotColor;
  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: cs.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: kGapMd),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: kGapMd),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================ SETTINGS (rules)
/// A settings row with a coloured leading glyph — a "control panel" look that
/// differs from list tiles and cards.
class SettingRow extends StatelessWidget {
  const SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kGapSm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: kRadiusTile,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: kGapMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: kGapSm),
          trailing,
        ],
      ),
    );
  }
}

/// A card with a bold left accent stripe — used for rule cards and duplicate
/// groups so they read as "records", distinct from plain surfaces.
class AccentCard extends StatelessWidget {
  const AccentCard({
    required this.accent,
    required this.child,
    super.key,
    this.margin,
  });

  final Color accent;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: kGapMd),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: kRadiusCard,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accent),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// ============================================================ DIFF (preview)
/// A before → after row — the preview reads like a code diff.
class DiffRow extends StatelessWidget {
  const DiffRow({
    required this.original,
    super.key,
    this.replacement,
    this.removed = false,
  });

  final String original;
  final String? replacement;
  final bool removed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(kGapMd),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: kRadiusTile,
      ),
      child: Row(
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                original,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  decoration: removed ? TextDecoration.lineThrough : null,
                  decorationColor: cs.error,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGapSm),
            child: Icon(
              removed ? Icons.block : Icons.arrow_forward,
              size: 16,
              color: removed ? cs.error : cs.primary,
            ),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                removed ? '—' : (replacement ?? ''),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: removed ? cs.error : cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================ shared states
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kGapMd, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: kRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: kGapXs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kGapXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: cs.primary),
            ),
            const SizedBox(height: kGapLg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: kGapSm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error / call-to-action state with an AdaptiveButton.
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kGapXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: cs.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: cs.error),
            ),
            const SizedBox(height: kGapLg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: kGapSm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant),
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
    final String resolvedValue = valueDirection == TextDirection.ltr
        ? '‎${value.trim()}‎'
        : value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kGapMd),
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: kRadiusTile,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: kGapXs),
          Directionality(
            textDirection: valueDirection,
            child: Text(
              resolvedValue,
              textDirection: valueDirection,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: valueColor ?? cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
