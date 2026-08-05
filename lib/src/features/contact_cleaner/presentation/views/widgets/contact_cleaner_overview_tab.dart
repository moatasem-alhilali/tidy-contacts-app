// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
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
      return EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_result_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_result_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.16),
      );
    }

    final List<AnalyzedPhoneNumber> issues = currentAnalysis.issuePhones;

    return ContactCleanerLocalPaginationWidget<AnalyzedPhoneNumber>(
      items: issues,
      paginationIdentity: currentAnalysis,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        return Column(
          children: [
            _StatsGrid(stats: currentAnalysis.stats),
            SizedBox(height: context.insets.md.h),
            ContactCleanerPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    LocaleKeys.contact_cleaner_issues_title.tr(),
                    style: context.textStyles.titleMedium.copyWith(
                      color: context.colors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.insets.sm.h),
                  TextWidget(
                    issues.isEmpty
                        ? LocaleKeys.contact_cleaner_no_issues_message.tr()
                        : LocaleKeys.contact_cleaner_issues_visible.tr(
                            namedArgs: {
                              'visible': '$visibleCount',
                              'total': '$totalCount',
                            },
                          ),
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.onSecondary,
                    ),
                  ),
                  SizedBox(height: context.insets.md.h),
                  Wrap(
                    spacing: context.insets.sm.w,
                    runSpacing: context.insets.sm.h,
                    children: [
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_formatting_count.tr(
                          namedArgs: {
                            'count':
                                '${currentAnalysis.stats.formattingIssues}',
                          },
                        ),
                        backgroundColor: context.colors.secondary,
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_missing_country_count
                            .tr(
                              namedArgs: {
                                'count':
                                    '${currentAnalysis.stats.missingCountryCode}',
                              },
                            ),
                        backgroundColor: context.colors.brand10Color,
                        textColor: context.colors.primary,
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_unmatched_count.tr(
                          namedArgs: {
                            'count':
                                '${currentAnalysis.stats.unmatchedLocalNumbers}',
                          },
                        ),
                        backgroundColor: context.colors.brand10Color,
                        textColor: context.colors.primary,
                      ),
                      ContactCleanerTag(
                        label: LocaleKeys.contact_cleaner_invalid_count.tr(
                          namedArgs: {
                            'count': '${currentAnalysis.stats.invalidNumbers}',
                          },
                        ),
                        backgroundColor: context.colors.errorLight,
                        textColor: context.colors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      emptyWidget: EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_formatting_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_formatting_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.12),
      ),
      itemBuilder: (AnalyzedPhoneNumber phone) => _IssueCard(phone: phone),
      separatorWidget: SizedBox(height: context.insets.sm.h),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final AnalysisStats stats;

  @override
  Widget build(BuildContext context) {
    final double width =
        (context.width - (context.insets.mn.w * 2) - context.insets.sm.w) / 2;

    return Wrap(
      spacing: context.insets.sm.w,
      runSpacing: context.insets.sm.h,
      children: [
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_total_contacts.tr(),
          value: '${stats.totalContacts}',
          width: width,
          backgroundColor: context.colors.brand10Color,
          valueColor: context.colors.primary,
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
          backgroundColor: context.colors.brand10Color,
          valueColor: context.colors.primary,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_duplicates.tr(),
          value: '${stats.duplicateEntries}',
          width: width,
          backgroundColor: context.colors.errorLight,
          valueColor: context.colors.error,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_corrected.tr(),
          value: '${stats.correctedNumbers}',
          width: width,
          backgroundColor: context.colors.primaryFixedLight,
          valueColor: context.colors.primaryFixed,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_invalid.tr(),
          value: '${stats.invalidNumbers}',
          width: width,
          backgroundColor: context.colors.errorLight,
          valueColor: context.colors.error,
        ),
      ],
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.phone});

  final AnalyzedPhoneNumber phone;

  @override
  Widget build(BuildContext context) {
    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.sm.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  phone.contactName,
                  style: context.textStyles.titleMedium.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_number_index.tr(
                  namedArgs: {'index': '${phone.entryIndex + 1}'},
                ),
                backgroundColor: context.colors.secondary,
                textColor: context.colors.onSecondary,
              ),
            ],
          ),
          SizedBox(height: context.insets.md.h),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_original_number.tr(),
            value: phone.originalNumber,
            valueDirection: ui.TextDirection.ltr,
          ),
          SizedBox(height: context.insets.sm.h),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_analysis_result.tr(),
            value:
                phone.normalizedNumber ??
                LocaleKeys.contact_cleaner_no_rule_applied.tr(),
            valueDirection: phone.normalizedNumber == null
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            backgroundColor: phone.normalizedNumber == null
                ? context.colors.secondary
                : context.colors.brand10Color,
            valueColor: phone.normalizedNumber == null
                ? context.colors.onPrimaryContainer
                : context.colors.primary,
          ),
          SizedBox(height: context.insets.md.h),
          Wrap(
            spacing: context.insets.sm.w,
            runSpacing: context.insets.sm.h,
            children: [
              if (phone.hasFormattingNoise)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_format.tr(),
                ),
              if (phone.hadArabicDigits)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_arabic_digits.tr(),
                  backgroundColor: context.colors.brand10Color,
                  textColor: context.colors.primary,
                ),
              if (phone.isMissingCountryCode)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_missing_country.tr(),
                  backgroundColor: context.colors.brand10Color,
                  textColor: context.colors.primary,
                ),
              if (phone.isUnmatchedLocal)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_unmatched_rule.tr(),
                  backgroundColor: context.colors.secondary,
                ),
              if (phone.isInvalidLength)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_invalid_length.tr(),
                  backgroundColor: context.colors.errorLight,
                  textColor: context.colors.error,
                ),
              if (phone.wasCorrected)
                ContactCleanerTag(
                  label: LocaleKeys.contact_cleaner_issue_fixable.tr(),
                  backgroundColor: context.colors.primaryFixedLight,
                  textColor: context.colors.primaryFixed,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
