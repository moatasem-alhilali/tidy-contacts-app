// Preview — redesigned as a DIFF view:
//   • a receipt-style summary (icon rows), distinct from the overview chips
//   • each planned change as before → after DiffRows inside a static card

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_design.dart';
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
        final ColorScheme cs = Theme.of(context).colorScheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryReceipt(plan: currentPlan),
            const SizedBox(height: kGapMd),
            Text(
              LocaleKeys.contact_cleaner_preview_visible.tr(
                namedArgs: {'visible': '$visibleCount', 'total': '$totalCount'},
              ),
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: kGapSm),
          ],
        );
      },
      emptyWidget: ContactCleanerEmptyState(
        icon: Icons.task_alt_outlined,
        title: LocaleKeys.contact_cleaner_no_changes_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_no_changes_subtitle.tr(),
      ),
      itemBuilder: (_PreviewEntry entry) => entry.mergePlan != null
          ? _MergeCard(plan: entry.mergePlan!)
          : _ContactDiffCard(planEntry: entry.contactPlan!),
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

class _SummaryReceipt extends StatelessWidget {
  const _SummaryReceipt({required this.plan});

  final CleanupPlan plan;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final List<(IconData, String, String, Color)> rows =
        <(IconData, String, String, Color)>[
          (
            Icons.person_outline,
            LocaleKeys.contact_cleaner_metric_contacts_update.tr(),
            '${plan.contactsToUpdate}',
            cs.primary,
          ),
          (
            Icons.auto_fix_high,
            LocaleKeys.contact_cleaner_metric_numbers_normalized.tr(),
            '${plan.numbersNormalized}',
            cs.tertiary,
          ),
          (
            Icons.remove_circle_outline,
            LocaleKeys.contact_cleaner_metric_numbers_removed.tr(),
            '${plan.numbersRemoved}',
            cs.error,
          ),
          (
            Icons.merge_type,
            LocaleKeys.contact_cleaner_metric_contacts_merge_delete.tr(),
            '${plan.contactsToDelete}',
            cs.secondary,
          ),
        ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kGapLg, vertical: kGapSm),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: kRadiusCard,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kGapSm),
              child: Row(
                children: [
                  Icon(rows[i].$1, size: 20, color: rows[i].$4),
                  const SizedBox(width: kGapMd),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    rows[i].$3,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: rows[i].$4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.title, required this.tag, required this.body});

  final String title;
  final Widget tag;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(kGapMd),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: kRadiusCard,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
              tag,
            ],
          ),
          const SizedBox(height: kGapMd),
          body,
        ],
      ),
    );
  }
}

class _MergeCard extends StatelessWidget {
  const _MergeCard({required this.plan});

  final MergePlan plan;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return _CardShell(
      title: plan.primaryContactName,
      tag: ContactCleanerTag(
        icon: Icons.merge_type,
        label: LocaleKeys.contact_cleaner_merge_operation.tr(),
        backgroundColor: cs.primaryContainer,
        textColor: cs.onPrimaryContainer,
      ),
      body: Column(
        children: [
          for (final String contactName in plan.contactNames)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: Row(
                children: [
                  Icon(
                    contactName == plan.primaryContactName
                        ? Icons.star
                        : Icons.subdirectory_arrow_right,
                    size: 16,
                    color: contactName == plan.primaryContactName
                        ? cs.tertiary
                        : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: kGapSm),
                  Expanded(
                    child: Text(
                      contactName,
                      style: TextStyle(color: cs.onSurface),
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

class _ContactDiffCard extends StatelessWidget {
  const _ContactDiffCard({required this.planEntry});

  final ContactCleanupPlanEntry planEntry;

  @override
  Widget build(BuildContext context) {
    final List<PlannedPhoneChange> changedPhones = planEntry.phoneChanges
        .where(
          (PlannedPhoneChange change) =>
              !change.keep || change.needsReplacement,
        )
        .toList();

    return _CardShell(
      title: planEntry.contactName,
      tag: ContactCleanerTag(
        icon: Icons.edit_outlined,
        label: LocaleKeys.contact_cleaner_update_contact.tr(),
      ),
      body: Column(
        children: [
          for (final PlannedPhoneChange change in changedPhones)
            Padding(
              padding: const EdgeInsets.only(bottom: kGapSm),
              child: DiffRow(
                original: change.originalNumber,
                replacement: change.replacementNumber,
                removed: !change.keep,
              ),
            ),
        ],
      ),
    );
  }
}
