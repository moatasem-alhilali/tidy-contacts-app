// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
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
      return EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_changes_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_changes_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.16),
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
        return Column(
          children: [
            _PreviewMetrics(plan: currentPlan),
            SizedBox(height: context.insets.md.h),
            ContactCleanerPanel(
              child: TextWidget(
                LocaleKeys.contact_cleaner_preview_visible.tr(
                  namedArgs: {
                    'visible': '$visibleCount',
                    'total': '$totalCount',
                  },
                ),
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
            ),
          ],
        );
      },
      emptyWidget: EmptyWidget(
        title: LocaleKeys.contact_cleaner_no_changes_title.tr(),
        subTitle: LocaleKeys.contact_cleaner_no_changes_subtitle.tr(),
        padding: EdgeInsets.symmetric(vertical: context.height * 0.16),
      ),
      itemBuilder: (_PreviewEntry entry) => entry.mergePlan != null
          ? _MergePlanCard(plan: entry.mergePlan!)
          : _ContactPlanCard(planEntry: entry.contactPlan!),
      separatorWidget: SizedBox(height: context.insets.sm.h),
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
    final double width =
        (context.width - (context.insets.mn.w * 2) - context.insets.sm.w) / 2;

    return Wrap(
      spacing: context.insets.sm.w,
      runSpacing: context.insets.sm.h,
      children: [
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_metric_contacts_update.tr(),
          value: '${plan.contactsToUpdate}',
          width: width,
          backgroundColor: context.colors.brand10Color,
          valueColor: context.colors.primary,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_metric_numbers_normalized.tr(),
          value: '${plan.numbersNormalized}',
          width: width,
          backgroundColor: context.colors.primaryFixedLight,
          valueColor: context.colors.primaryFixed,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_metric_numbers_removed.tr(),
          value: '${plan.numbersRemoved}',
          width: width,
          backgroundColor: context.colors.errorLight,
          valueColor: context.colors.error,
        ),
        ContactCleanerStatTile(
          title: LocaleKeys.contact_cleaner_metric_contacts_merge_delete.tr(),
          value: '${plan.contactsToDelete}',
          width: width,
        ),
      ],
    );
  }
}

class _MergePlanCard extends StatelessWidget {
  const _MergePlanCard({required this.plan});

  final MergePlan plan;

  @override
  Widget build(BuildContext context) {
    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.sm.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactCleanerTag(
            label: LocaleKeys.contact_cleaner_merge_operation.tr(),
            backgroundColor: context.colors.brand10Color,
            textColor: context.colors.primary,
          ),
          SizedBox(height: context.insets.md.h),
          TextWidget(
            plan.primaryContactName,
            style: context.textStyles.titleMedium.copyWith(
              color: context.colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.insets.sm.h),
          TextWidget(
            LocaleKeys.contact_cleaner_merge_subtitle.tr(),
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.onSecondary,
            ),
          ),
          SizedBox(height: context.insets.md.h),
          ...plan.contactNames.map(
            (String contactName) => Padding(
              padding: EdgeInsets.only(bottom: context.insets.sm.h),
              child: ContactCleanerLabeledValue(
                label: contactName == plan.primaryContactName
                    ? LocaleKeys.contact_cleaner_merge_primary_contact.tr()
                    : LocaleKeys.contact_cleaner_merge_secondary_contact.tr(),
                value: contactName,
                backgroundColor: contactName == plan.primaryContactName
                    ? context.colors.primaryFixedLight
                    : context.colors.secondary,
                valueColor: contactName == plan.primaryContactName
                    ? context.colors.primaryFixed
                    : context.colors.onPrimaryContainer,
              ),
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
    final List<PlannedPhoneChange> changedPhones = planEntry.phoneChanges
        .where(
          (PlannedPhoneChange change) =>
              !change.keep || change.needsReplacement,
        )
        .toList();

    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.sm.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactCleanerTag(
            label: LocaleKeys.contact_cleaner_update_contact.tr(),
            backgroundColor: context.colors.secondary,
            textColor: context.colors.onSecondary,
          ),
          SizedBox(height: context.insets.md.h),
          TextWidget(
            planEntry.contactName,
            style: context.textStyles.titleMedium.copyWith(
              color: context.colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.insets.md.h),
          ...changedPhones.asMap().entries.map(
            (MapEntry<int, PlannedPhoneChange> entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == changedPhones.length - 1
                    ? 0
                    : context.insets.md.h,
              ),
              child: _PhoneChangeCard(change: entry.value),
            ),
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
    final bool isRemoval = !change.keep;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isRemoval
            ? context.colors.errorLight
            : context.colors.primaryFixedLight,
        borderRadius: BorderRadius.all(context.corners.rm),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.insets.sm.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactCleanerTag(
              label: isRemoval
                  ? LocaleKeys.contact_cleaner_number_will_be_removed.tr()
                  : LocaleKeys.contact_cleaner_number_will_be_replaced.tr(),
              backgroundColor: context.colors.surface,
              textColor: isRemoval
                  ? context.colors.error
                  : context.colors.primaryFixed,
            ),
            SizedBox(height: context.insets.sm.h),
            ContactCleanerLabeledValue(
              label: LocaleKeys.contact_cleaner_current_number.tr(),
              value: change.originalNumber,
              valueDirection: ui.TextDirection.ltr,
              backgroundColor: context.colors.surface,
            ),
            if (!isRemoval) ...[
              SizedBox(height: context.insets.sm.h),
              ContactCleanerLabeledValue(
                label: LocaleKeys.contact_cleaner_replacement_number.tr(),
                value: change.replacementNumber ?? '',
                valueDirection: ui.TextDirection.ltr,
                backgroundColor: context.colors.surface,
                valueColor: context.colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
