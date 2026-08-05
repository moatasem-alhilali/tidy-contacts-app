// Duplicates tab: cross-contact & within-contact duplicate groups.
// Each group is an AdaptiveExpansionTile revealing its occurrences.

import 'dart:ui' as ui;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
      return ContactCleanerEmptyState(
        icon: Icons.copy_all_outlined,
        title: LocaleKeys.contact_cleaner_no_duplicates_data_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_duplicates_data_subtitle.tr(),
      );
    }

    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
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
          crossContact: true,
        ),
      ),
      ...withinDuplicates.map(
        (DuplicateGroup group) => _DuplicateSectionItem(
          group: group,
          sectionTitle: LocaleKeys.contact_cleaner_duplicates_within_contact
              .tr(),
          crossContact: false,
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
              Text(
                LocaleKeys.contact_cleaner_duplicates_report_title.tr(),
                style: tt.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: kGapSm),
              Text(
                LocaleKeys.contact_cleaner_duplicates_report_summary.tr(
                  namedArgs: {
                    'visible': '$visibleCount',
                    'total': '$totalCount',
                    'cross': '${crossDuplicates.length}',
                    'within': '${withinDuplicates.length}',
                  },
                ),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
      emptyWidget: ContactCleanerEmptyState(
        icon: Icons.verified_outlined,
        title: LocaleKeys.contact_cleaner_no_duplicates_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_duplicates_subtitle.tr(),
      ),
      itemBuilder: (_DuplicateSectionItem item) =>
          _DuplicateGroupCard(item: item),
    );
  }
}

class _DuplicateSectionItem {
  const _DuplicateSectionItem({
    required this.group,
    required this.sectionTitle,
    required this.crossContact,
  });

  final DuplicateGroup group;
  final String sectionTitle;
  final bool crossContact;
}

class _DuplicateGroupCard extends StatelessWidget {
  const _DuplicateGroupCard({required this.item});

  final _DuplicateSectionItem item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final DuplicateGroup group = item.group;
    final Color badgeBg = item.crossContact
        ? cs.errorContainer
        : cs.primaryContainer;
    final Color badgeFg = item.crossContact
        ? cs.onErrorContainer
        : cs.onPrimaryContainer;

    return ContactCleanerPanel(
      padding: const EdgeInsets.symmetric(horizontal: kGapSm),
      child: AdaptiveExpansionTile(
        title: Text(
          group.displayNumber ?? group.key,
          textDirection: ui.TextDirection.ltr,
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(item.sectionTitle),
        trailing: ContactCleanerTag(
          label: '${group.occurrences.length}',
          backgroundColor: badgeBg,
          textColor: badgeFg,
        ),
        childrenPadding: const EdgeInsets.only(bottom: kGapMd),
        children: [
          for (final DuplicateOccurrence occurrence in group.occurrences)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: _OccurrenceTile(occurrence: occurrence),
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: kRadiusTile,
      ),
      child: Padding(
        padding: const EdgeInsets.all(kGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              occurrence.contactName,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: kGapSm),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_original_number.tr(),
              value: occurrence.originalNumber,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: cs.surface,
            ),
            const SizedBox(height: kGapSm),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_after_normalization.tr(),
              value: occurrence.normalizedNumber ?? occurrence.canonicalInput,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: cs.surface,
              valueColor: cs.primary,
            ),
          ],
        ),
      ),
    );
  }
}
