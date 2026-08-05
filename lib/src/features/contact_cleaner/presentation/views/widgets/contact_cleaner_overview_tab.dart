// Overview — redesigned as a DASHBOARD:
//   • a circular health ScoreRing
//   • a horizontal strip of colourful MetricChips
//   • issues shown as a left-rail Timeline feed (not cards)

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_design.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_local_pagination_widget.dart';

class ContactCleanerOverviewTab extends StatelessWidget {
  const ContactCleanerOverviewTab({required this.analysis, super.key});

  final ContactAnalysisResult? analysis;

  @override
  Widget build(BuildContext context) {
    final ContactAnalysisResult? currentAnalysis = analysis;
    if (currentAnalysis == null) {
      return ContactCleanerEmptyState(
        icon: Icons.analytics_outlined,
        title: LocaleKeys.contact_cleaner_no_result_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_result_subtitle.tr(),
      );
    }

    final AnalysisStats stats = currentAnalysis.stats;
    final List<AnalyzedPhoneNumber> issues = currentAnalysis.issuePhones;
    final double percent = stats.totalNumbers == 0
        ? 1
        : (stats.totalNumbers - issues.length) / stats.totalNumbers;

    return ContactCleanerLocalPaginationWidget<AnalyzedPhoneNumber>(
      items: issues,
      paginationIdentity: currentAnalysis,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        final ColorScheme cs = Theme.of(context).colorScheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ScoreRing(
                  percent: percent,
                  centerValue: '${(percent * 100).round()}%',
                  caption: LocaleKeys.contact_cleaner_clean_score.tr(),
                ),
                const SizedBox(width: kGapLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.contact_cleaner_issues_title.tr(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: kGapXs),
                      Text(
                        issues.isEmpty
                            ? LocaleKeys.contact_cleaner_no_issues_message.tr()
                            : LocaleKeys.contact_cleaner_issues_visible.tr(
                                namedArgs: {
                                  'visible': '$visibleCount',
                                  'total': '$totalCount',
                                },
                              ),
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: kGapLg),
            SizedBox(
              height: 104,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  MetricChip(
                    icon: Icons.people_alt_outlined,
                    value: '${stats.totalContacts}',
                    label: LocaleKeys.contact_cleaner_total_contacts.tr(),
                    color: cs.primary,
                  ),
                  const SizedBox(width: kGapSm),
                  MetricChip(
                    icon: Icons.tag,
                    value: '${stats.totalNumbers}',
                    label: LocaleKeys.contact_cleaner_total_numbers.tr(),
                    color: cs.secondary,
                  ),
                  const SizedBox(width: kGapSm),
                  MetricChip(
                    icon: Icons.public_off,
                    value: '${stats.missingCountryCode}',
                    label: LocaleKeys.contact_cleaner_missing_country.tr(),
                    color: cs.tertiary,
                  ),
                  const SizedBox(width: kGapSm),
                  MetricChip(
                    icon: Icons.copy_all_outlined,
                    value: '${stats.duplicateEntries}',
                    label: LocaleKeys.contact_cleaner_duplicates.tr(),
                    color: cs.error,
                  ),
                  const SizedBox(width: kGapSm),
                  MetricChip(
                    icon: Icons.auto_fix_high,
                    value: '${stats.correctedNumbers}',
                    label: LocaleKeys.contact_cleaner_corrected.tr(),
                    color: cs.primary,
                  ),
                  const SizedBox(width: kGapSm),
                  MetricChip(
                    icon: Icons.report_gmailerrorred,
                    value: '${stats.invalidNumbers}',
                    label: LocaleKeys.contact_cleaner_invalid.tr(),
                    color: cs.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kGapLg),
          ],
        );
      },
      emptyWidget: ContactCleanerEmptyState(
        icon: Icons.verified_outlined,
        title: LocaleKeys.contact_cleaner_no_formatting_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_formatting_subtitle.tr(),
      ),
      itemBuilder: (AnalyzedPhoneNumber phone) => _IssueTimelineTile(phone: phone),
    );
  }
}

class _IssueTimelineTile extends StatelessWidget {
  const _IssueTimelineTile({required this.phone});

  final AnalyzedPhoneNumber phone;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool severe = phone.isInvalidLength || phone.isMissingCountryCode;
    final Color dot = severe ? cs.error : cs.primary;

    return TimelineTile(
      dotColor: dot,
      child: Container(
        padding: const EdgeInsets.all(kGapMd),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: kRadiusTile,
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phone.contactName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: kGapSm),
            Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      phone.originalNumber,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, size: 14, color: cs.onSurfaceVariant),
                Expanded(
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      phone.normalizedNumber ??
                          LocaleKeys.contact_cleaner_no_rule_applied.tr(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: phone.normalizedNumber == null
                            ? cs.onSurfaceVariant
                            : cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kGapSm),
            Wrap(
              spacing: kGapSm,
              runSpacing: kGapXs,
              children: [
                if (phone.hasFormattingNoise)
                  ContactCleanerTag(
                    label: LocaleKeys.contact_cleaner_issue_format.tr(),
                  ),
                if (phone.hadArabicDigits)
                  ContactCleanerTag(
                    label: LocaleKeys.contact_cleaner_issue_arabic_digits.tr(),
                    backgroundColor: cs.primaryContainer,
                    textColor: cs.onPrimaryContainer,
                  ),
                if (phone.isMissingCountryCode)
                  ContactCleanerTag(
                    label: LocaleKeys.contact_cleaner_issue_missing_country.tr(),
                    backgroundColor: cs.tertiaryContainer,
                    textColor: cs.onTertiaryContainer,
                  ),
                if (phone.isInvalidLength)
                  ContactCleanerTag(
                    label: LocaleKeys.contact_cleaner_issue_invalid_length.tr(),
                    backgroundColor: cs.errorContainer,
                    textColor: cs.onErrorContainer,
                  ),
                if (phone.wasCorrected)
                  ContactCleanerTag(
                    label: LocaleKeys.contact_cleaner_issue_fixable.tr(),
                    backgroundColor: cs.primaryContainer,
                    textColor: cs.onPrimaryContainer,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
