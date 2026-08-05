// Duplicates — expandable groups (its own visual language: bordered tiles
// with a count badge and an icon that encodes cross vs within contact).

import 'dart:ui' as ui;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_design.dart';
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

    final List<DuplicateGroup> crossDuplicates =
        currentAnalysis.crossContactDuplicates;
    final List<DuplicateGroup> withinDuplicates =
        currentAnalysis.withinContactDuplicates;
    final List<_DuplicateSectionItem> duplicateItems = <_DuplicateSectionItem>[
      ...crossDuplicates.map(
        (DuplicateGroup group) =>
            _DuplicateSectionItem(group: group, crossContact: true),
      ),
      ...withinDuplicates.map(
        (DuplicateGroup group) =>
            _DuplicateSectionItem(group: group, crossContact: false),
      ),
    ];

    return ContactCleanerLocalPaginationWidget<_DuplicateSectionItem>(
      items: duplicateItems,
      paginationIdentity: currentAnalysis,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        final ColorScheme cs = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.all(kGapLg),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: kRadiusCard,
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.copy_all_rounded, color: cs.primary, size: 28),
              const SizedBox(width: kGapMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contact_cleaner_duplicates_report_title.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: kGapXs),
                    Text(
                      LocaleKeys.contact_cleaner_duplicates_report_summary.tr(
                        namedArgs: {
                          'visible': '$visibleCount',
                          'total': '$totalCount',
                          'cross': '${crossDuplicates.length}',
                          'within': '${withinDuplicates.length}',
                        },
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
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
          _DuplicateGroupTile(item: item),
    );
  }
}

class _DuplicateSectionItem {
  const _DuplicateSectionItem({required this.group, required this.crossContact});

  final DuplicateGroup group;
  final bool crossContact;
}

class _DuplicateGroupTile extends StatelessWidget {
  const _DuplicateGroupTile({required this.item});

  final _DuplicateSectionItem item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final DuplicateGroup group = item.group;
    final Color accent = item.crossContact ? cs.error : cs.tertiary;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: kRadiusCard,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: AdaptiveExpansionTile(
        leading: Icon(
          item.crossContact ? Icons.people_alt : Icons.person,
          color: accent,
        ),
        title: Text(
          group.displayNumber ?? group.key,
          textDirection: ui.TextDirection.ltr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        subtitle: Text(
          item.crossContact
              ? LocaleKeys.contact_cleaner_duplicates_cross_contacts.tr()
              : LocaleKeys.contact_cleaner_duplicates_within_contact.tr(),
        ),
        trailing: ContactCleanerTag(
          label: '${group.occurrences.length}',
          backgroundColor: accent.withValues(alpha: 0.15),
          textColor: accent,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(kGapMd, 0, kGapMd, kGapMd),
        children: [
          for (final DuplicateOccurrence occurrence in group.occurrences)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: accent,
                  ),
                  const SizedBox(width: kGapSm),
                  Expanded(
                    child: Text(
                      occurrence.contactName,
                      style: TextStyle(color: cs.onSurface),
                    ),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Text(
                      occurrence.originalNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
