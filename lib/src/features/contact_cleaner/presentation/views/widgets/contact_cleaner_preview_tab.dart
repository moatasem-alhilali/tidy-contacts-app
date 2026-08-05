// Preview tab: the planned changes before applying.
// Metrics as stat cards; each planned change as an AdaptiveExpansionTile.

import 'dart:ui' as ui;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_local_pagination_widget.dart';

class ContactCleanerPreviewTab extends StatelessWidget {
  const ContactCleanerPreviewTab({required this.plan, super.key});

  final CleanupPlan? plan;

  @override
  Widget build(BuildContext context) {
    final CleanupPlan? currentPlan = plan;
    if (currentPlan == null || !currentPlan.hasChanges) {
      return ContactCleanerEmptyState(
        icon: Icons.task_alt_outlined,
        title: LocaleKeys.contact_cleaner_no_changes_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_changes_subtitle.tr(),
      );
    }

    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final List<ContactCleanupPlanEntry> changedContacts = currentPlan
        .contactPlans
        .where((ContactCleanupPlanEntry planEntry) => planEntry.hasChanges)
        .toList();
    final List<_PreviewEntry> previewEntries = <_PreviewEntry>[
      ...currentPlan.mergePlans.map(_PreviewEntry.merge),
      ...changedContacts.map(_PreviewEntry.contact),
    ];

    return ContactCleanerLocalPaginationWidget<_PreviewEntry>(
      items: previewEntries,
      paginationIdentity: currentPlan,
      headerBuilder: (BuildContext context, int visibleCount, int totalCount) {
        return Column(
          children: [
            _PreviewMetrics(plan: currentPlan),
            const SizedBox(height: kGapMd),
            ContactCleanerPanel(
              child: Text(
                LocaleKeys.contact_cleaner_preview_visible.tr(
                  namedArgs: {
                    'visible': '$visibleCount',
                    'total': '$totalCount',
                  },
                ),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        );
      },
      emptyWidget: ContactCleanerEmptyState(
        icon: Icons.task_alt_outlined,
        title: LocaleKeys.contact_cleaner_no_changes_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_changes_subtitle.tr(),
      ),
      itemBuilder: (_PreviewEntry entry) => entry.mergePlan != null
          ? _MergePlanCard(plan: entry.mergePlan!)
          : _ContactPlanCard(planEntry: entry.contactPlan!),
    );
  }
}

class _PreviewEntry {
  const _PreviewEntry._({this.mergePlan, this.contactPlan});

  const _PreviewEntry.merge(MergePlan value) : this._(mergePlan: value);

  const _PreviewEntry.contact(ContactCleanupPlanEntry value)
    : this._(contactPlan: value);

  final MergePlan? mergePlan;
  final ContactCleanupPlanEntry? contactPlan;
}

class _PreviewMetrics extends StatelessWidget {
  const _PreviewMetrics({required this.plan});

  final CleanupPlan plan;

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
              title: LocaleKeys.contact_cleaner_metric_contacts_update.tr(),
              value: '${plan.contactsToUpdate}',
              width: width,
              backgroundColor: cs.primaryContainer,
              valueColor: cs.onPrimaryContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_metric_numbers_normalized.tr(),
              value: '${plan.numbersNormalized}',
              width: width,
              backgroundColor: cs.tertiaryContainer,
              valueColor: cs.onTertiaryContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_metric_numbers_removed.tr(),
              value: '${plan.numbersRemoved}',
              width: width,
              backgroundColor: cs.errorContainer,
              valueColor: cs.onErrorContainer,
            ),
            ContactCleanerStatTile(
              title: LocaleKeys.contact_cleaner_metric_contacts_merge_delete
                  .tr(),
              value: '${plan.contactsToDelete}',
              width: width,
            ),
          ],
        );
      },
    );
  }
}

class _MergePlanCard extends StatelessWidget {
  const _MergePlanCard({required this.plan});

  final MergePlan plan;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return ContactCleanerPanel(
      padding: const EdgeInsets.symmetric(horizontal: kGapSm),
      child: AdaptiveExpansionTile(
        leading: Icon(Icons.merge_type, color: cs.primary),
        title: Text(
          plan.primaryContactName,
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(LocaleKeys.contact_cleaner_merge_operation.tr()),
        childrenPadding: const EdgeInsets.only(bottom: kGapMd),
        children: [
          for (final String contactName in plan.contactNames)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: ContactCleanerLabeledValue(
                label: contactName == plan.primaryContactName
                    ? LocaleKeys.contact_cleaner_merge_primary_contact.tr()
                    : LocaleKeys.contact_cleaner_merge_secondary_contact.tr(),
                value: contactName,
                backgroundColor: contactName == plan.primaryContactName
                    ? cs.tertiaryContainer
                    : cs.surfaceContainerHighest,
                valueColor: contactName == plan.primaryContactName
                    ? cs.onTertiaryContainer
                    : cs.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactPlanCard extends StatelessWidget {
  const _ContactPlanCard({required this.planEntry});

  final ContactCleanupPlanEntry planEntry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final List<PlannedPhoneChange> changedPhones = planEntry.phoneChanges
        .where(
          (PlannedPhoneChange change) =>
              !change.keep || change.needsReplacement,
        )
        .toList();

    return ContactCleanerPanel(
      padding: const EdgeInsets.symmetric(horizontal: kGapSm),
      child: AdaptiveExpansionTile(
        leading: Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
        title: Text(
          planEntry.contactName,
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(LocaleKeys.contact_cleaner_update_contact.tr()),
        childrenPadding: const EdgeInsets.only(bottom: kGapMd),
        children: [
          for (final PlannedPhoneChange change in changedPhones)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: _PhoneChangeCard(change: change),
            ),
        ],
      ),
    );
  }
}

class _PhoneChangeCard extends StatelessWidget {
  const _PhoneChangeCard({required this.change});

  final PlannedPhoneChange change;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isRemoval = !change.keep;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isRemoval ? cs.errorContainer : cs.tertiaryContainer,
        borderRadius: kRadiusTile,
      ),
      child: Padding(
        padding: const EdgeInsets.all(kGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactCleanerTag(
              label: isRemoval
                  ? LocaleKeys.contact_cleaner_number_will_be_removed.tr()
                  : LocaleKeys.contact_cleaner_number_will_be_replaced.tr(),
              backgroundColor: cs.surface,
              textColor: isRemoval ? cs.error : cs.onTertiaryContainer,
            ),
            const SizedBox(height: kGapSm),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_current_number.tr(),
              value: change.originalNumber,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: cs.surface,
            ),
            if (!isRemoval) ...[
              const SizedBox(height: kGapSm),
              ContactCleanerLabeledValue(
                label: LocaleKeys.contact_cleaner_replacement_number.tr(),
                value: change.replacementNumber ?? '',
                valueDirection: ui.TextDirection.ltr,
                backgroundColor: cs.surface,
                valueColor: cs.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
