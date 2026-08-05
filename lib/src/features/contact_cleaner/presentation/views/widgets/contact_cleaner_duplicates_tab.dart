// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_local_pagination_widget.dart';

class ContactCleanerDuplicatesTab extends StatelessWidget {
  const ContactCleanerDuplicatesTab({required this.analysis, super.key});

  final ContactAnalysisResult? analysis;

  @override
  Widget build(BuildContext context) {
    final ContactAnalysisResult? currentAnalysis = analysis;
    if (currentAnalysis == null) {
      return EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_duplicates_data_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_duplicates_data_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.16),
      );
    }

    final List<DuplicateGroup> crossDuplicates =
        currentAnalysis.crossContactDuplicates;
    final List<DuplicateGroup> withinDuplicates =
        currentAnalysis.withinContactDuplicates;
    final List<_DuplicateSectionItem> duplicateItems = <_DuplicateSectionItem>[
      ...crossDuplicates.map(
        (DuplicateGroup group) => _DuplicateSectionItem(
          group: group,
          sectionTitle: LocaleKeys.contact_cleaner_duplicates_cross_contacts
              .tr(),
          tone: _DuplicateTone.crossContact,
        ),
      ),
      ...withinDuplicates.map(
        (DuplicateGroup group) => _DuplicateSectionItem(
          group: group,
          sectionTitle: LocaleKeys.contact_cleaner_duplicates_within_contact
              .tr(),
          tone: _DuplicateTone.withinContact,
        ),
      ),
    ];

    return ContactCleanerLocalPaginationWidget<_DuplicateSectionItem>(
      items: duplicateItems,
      paginationIdentity: currentAnalysis,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        return ContactCleanerPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                LocaleKeys.contact_cleaner_duplicates_report_title.tr(),
                style: context.textStyles.titleMedium.copyWith(
                  color: context.colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.insets.sm.h),
              TextWidget(
                LocaleKeys.contact_cleaner_duplicates_report_summary.tr(
                  namedArgs: {
                    'visible': '$visibleCount',
                    'total': '$totalCount',
                    'cross': '${crossDuplicates.length}',
                    'within': '${withinDuplicates.length}',
                  },
                ),
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
            ],
          ),
        );
      },
      emptyWidget: EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_duplicates_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_duplicates_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.1),
      ),
      itemBuilder: (_DuplicateSectionItem item) => _DuplicateGroupCard(
        group: item.group,
        sectionTitle: item.sectionTitle,
        tone: item.tone,
      ),
      separatorWidget: SizedBox(height: context.insets.sm.h),
    );
  }
}

enum _DuplicateTone { crossContact, withinContact }

class _DuplicateSectionItem {
  const _DuplicateSectionItem({
    required this.group,
    required this.sectionTitle,
    required this.tone,
  });

  final DuplicateGroup group;
  final String sectionTitle;
  final _DuplicateTone tone;
}

class _DuplicateGroupCard extends StatelessWidget {
  const _DuplicateGroupCard({
    required this.group,
    required this.sectionTitle,
    required this.tone,
  });

  final DuplicateGroup group;
  final String sectionTitle;
  final _DuplicateTone tone;

  @override
  Widget build(BuildContext context) {
    final Color badgeBackground = tone == _DuplicateTone.crossContact
        ? context.colors.errorLight
        : context.colors.brand10Color;
    final Color badgeTextColor = tone == _DuplicateTone.crossContact
        ? context.colors.error
        : context.colors.primary;

    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.sm.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: context.insets.sm.w,
            runSpacing: context.insets.sm.h,
            children: [
              ContactCleanerTag(
                label: sectionTitle,
                backgroundColor: badgeBackground,
                textColor: badgeTextColor,
              ),
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_duplicate_occurrences.tr(
                  namedArgs: {'count': '${group.occurrences.length}'},
                ),
                backgroundColor: context.colors.secondary,
                textColor: context.colors.onSecondary,
              ),
            ],
          ),
          SizedBox(height: context.insets.md.h),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_normalized_number.tr(),
            value: group.displayNumber ?? group.key,
            valueDirection: ui.TextDirection.ltr,
            backgroundColor: context.colors.brand10Color,
            valueColor: context.colors.primary,
          ),
          SizedBox(height: context.insets.md.h),
          ...group.occurrences.asMap().entries.map(
            (MapEntry<int, DuplicateOccurrence> entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == group.occurrences.length - 1
                    ? 0
                    : context.insets.sm.h,
              ),
              child: _OccurrenceTile(occurrence: entry.value),
            ),
          ),
        ],
      ),
    );
  }
}

class _OccurrenceTile extends StatelessWidget {
  const _OccurrenceTile({required this.occurrence});

  final DuplicateOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rm),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.insets.sm.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              occurrence.contactName,
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.insets.sm.h),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_original_number.tr(),
              value: occurrence.originalNumber,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: context.colors.surface,
            ),
            SizedBox(height: context.insets.sm.h),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_after_normalization.tr(),
              value: occurrence.normalizedNumber ?? occurrence.canonicalInput,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: context.colors.surface,
              valueColor: context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
