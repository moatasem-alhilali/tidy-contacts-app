// Overview tab: analysis stats + per-number issues.
// Built on the adaptive kit (AdaptiveCard-based) + Flutter ThemeData.

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';
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

    final List<AnalyzedPhoneNumber> issues = currentAnalysis.issuePhones;
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return ContactCleanerLocalPaginationWidget<AnalyzedPhoneNumber>(
      items: issues,
      paginationIdentity: currentAnalysis,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        return Column(
          children: [
            _StatsGrid(stats: currentAnalysis.stats),
            const SizedBox(height: kGapMd),
            ContactCleanerPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.contact_cleaner_issues_title.tr(),
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: kGapSm),
                  Text(
                    issues.isEmpty
                        ? LocaleKeys.contact_cleaner_no_issues_message.tr()
                        : LocaleKeys.contact_cleaner_issues_visible.tr(
                            namedArgs: {
                              'visible': '$visibleCount',
                              'total': '$totalCount',
                            },
                          ),
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: kGapMd),
                  Wrap(
                    spacing: kGapSm,
                    runSpacing: kGapSm,
                    children: [
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_formatting_count.tr(
                          namedArgs: {
                            'count':
                                '${currentAnalysis.stats.formattingIssues}',
                          },
                        ),
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_missing_country_count
                            .tr(
                              namedArgs: {
                                'count':
                                    '${currentAnalysis.stats.missingCountryCode}',
                              },
                            ),
                        backgroundColor: cs.primaryContainer,
                        textColor: cs.onPrimaryContainer,
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_unmatched_count.tr(
                          namedArgs: {
                            'count':
                                '${currentAnalysis.stats.unmatchedLocalNumbers}',
                          },
                        ),
                        backgroundColor: cs.primaryContainer,
                        textColor: cs.onPrimaryContainer,
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_invalid_count.tr(
                          namedArgs: {
                            'count': '${currentAnalysis.stats.invalidNumbers}',
                          },
                        ),
                        backgroundColor: cs.errorContainer,
                        textColor: cs.onErrorContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      emptyWidget: ContactCleanerEmptyState(
        icon: Icons.verified_outlined,
        title: LocaleKeys.contact_cleaner_no_formatting_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_formatting_subtitle.tr(),
      ),
      itemBuilder: (AnalyzedPhoneNumber phone) => _IssueCard(phone: phone),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final AnalysisStats stats;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = (constraints.maxWidth - kGapSm) / 2;
        return Wrap(
          spacing: kGapSm,
          runSpacing: kGapSm,
          children: [
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_total_contacts.tr(),
              value: '${stats.totalContacts}',
              width: width,
              backgroundColor: cs.primaryContainer,
              valueColor: cs.onPrimaryContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_total_numbers.tr(),
              value: '${stats.totalNumbers}',
              width: width,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_missing_country.tr(),
              value: '${stats.missingCountryCode}',
              width: width,
              backgroundColor: cs.primaryContainer,
              valueColor: cs.onPrimaryContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_duplicates.tr(),
              value: '${stats.duplicateEntries}',
              width: width,
              backgroundColor: cs.errorContainer,
              valueColor: cs.onErrorContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_corrected.tr(),
              value: '${stats.correctedNumbers}',
              width: width,
              backgroundColor: cs.tertiaryContainer,
              valueColor: cs.onTertiaryContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_invalid.tr(),
              value: '${stats.invalidNumbers}',
              width: width,
              backgroundColor: cs.errorContainer,
              valueColor: cs.onErrorContainer,
            ),
          ],
        );
      },
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.phone});

  final AnalyzedPhoneNumber phone;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return ContactCleanerPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  phone.contactName,
                  style: tt.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_number_index.tr(
                  namedArgs: {'index': '${phone.entryIndex + 1}'},
                ),
              ),
            ],
          ),
          const SizedBox(height: kGapMd),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_original_number.tr(),
            value: phone.originalNumber,
            valueDirection: ui.TextDirection.ltr,
          ),
          const SizedBox(height: kGapSm),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_analysis_result.tr(),
            value:
                phone.normalizedNumber ??
                LocaleKeys.contact_cleaner_no_rule_applied.tr(),
            valueDirection: phone.normalizedNumber == null
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            backgroundColor: phone.normalizedNumber == null
                ? null
                : cs.primaryContainer,
            valueColor: phone.normalizedNumber == null
                ? null
                : cs.onPrimaryContainer,
          ),
          const SizedBox(height: kGapMd),
          Wrap(
            spacing: kGapSm,
            runSpacing: kGapSm,
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
                  backgroundColor: cs.primaryContainer,
                  textColor: cs.onPrimaryContainer,
                ),
              if (phone.isUnmatchedLocal)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_unmatched_rule.tr(),
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
                  backgroundColor: cs.tertiaryContainer,
                  textColor: cs.onTertiaryContainer,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
