// Rules & options tab.
// Options -> AdaptiveListTile + AdaptiveSwitch
// Cross-contact strategy -> AdaptiveSegmentedControl
// Actions -> AdaptiveButton
// Each rule -> AdaptiveExpansionTile + AdaptivePopupMenuButton

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_rule_label_localizer.dart';

class ContactCleanerRulesTab extends StatelessWidget {
  const ContactCleanerRulesTab({
    required this.rules,
    required this.options,
    required this.onNormalizeChanged,
    required this.onWithinContactChanged,
    required this.onCrossContactChanged,
    required this.onAddRulePressed,
    required this.onEditRulePressed,
    required this.onDeleteRulePressed,
    required this.onAutoCleanPressed,
    super.key,
  });

  final List<NormalizationRule> rules;
  final CleanupOptions options;
  final ValueChanged<bool> onNormalizeChanged;
  final ValueChanged<bool> onWithinContactChanged;
  final ValueChanged<CrossContactDuplicateAction> onCrossContactChanged;
  final VoidCallback onAddRulePressed;
  final ValueChanged<NormalizationRule> onEditRulePressed;
  final ValueChanged<String> onDeleteRulePressed;
  final VoidCallback onAutoCleanPressed;

  static const List<CrossContactDuplicateAction> _crossActions =
      CrossContactDuplicateAction.values;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: context.insets.xl.h),
      children: [
        ContactCleanerPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                LocaleKeys.contact_cleaner_rules_title.tr(),
                style: context.textStyles.titleMedium.copyWith(
                  color: context.colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.insets.sm.h),
              TextWidget(
                LocaleKeys.contact_cleaner_rules_subtitle.tr(),
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
              SizedBox(height: context.insets.md.h),
              AdaptiveListTile(
                hideBottomDivider: true,
                title: Text(
                  LocaleKeys.contact_cleaner_option_normalize_title.tr(),
                ),
                subtitle: Text(
                  LocaleKeys.contact_cleaner_option_normalize_subtitle.tr(),
                ),
                trailing: AdaptiveSwitch(
                  value: options.normalizeNumbers,
                  onChanged: onNormalizeChanged,
                ),
              ),
              AdaptiveListTile(
                hideBottomDivider: true,
                title: Text(
                  LocaleKeys.contact_cleaner_option_within_contact_title.tr(),
                ),
                subtitle: Text(
                  LocaleKeys.contact_cleaner_option_within_contact_subtitle.tr(),
                ),
                trailing: AdaptiveSwitch(
                  value: options.removeDuplicatesWithinContact,
                  onChanged: onWithinContactChanged,
                ),
              ),
              SizedBox(height: context.insets.md.h),
              TextWidget(
                LocaleKeys.contact_cleaner_cross_contact_action_label.tr(),
                style: context.textStyles.labelLarge.copyWith(
                  color: context.colors.onSecondary,
                ),
              ),
              SizedBox(height: context.insets.sm.h),
              AdaptiveSegmentedControl(
                labels: _crossActions
                    .map((CrossContactDuplicateAction a) => _actionLabel(a))
                    .toList(),
                selectedIndex: _crossActions.indexOf(options.crossContactAction),
                onValueChanged: (int index) =>
                    onCrossContactChanged(_crossActions[index]),
              ),
              SizedBox(height: context.insets.md.h),
              SizedBox(
                width: double.infinity,
                child: AdaptiveButton(
                  onPressed: onAutoCleanPressed,
                  style: AdaptiveButtonStyle.tinted,
                  label: LocaleKeys.contact_cleaner_enable_auto_preset.tr(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.insets.md.h),
        SizedBox(
          width: double.infinity,
          child: AdaptiveButton.child(
            onPressed: onAddRulePressed,
            size: AdaptiveButtonSize.large,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 18),
                SizedBox(width: context.insets.sm.w),
                Text(LocaleKeys.contact_cleaner_add_rule.tr()),
              ],
            ),
          ),
        ),
        SizedBox(height: context.insets.md.h),
        if (rules.isEmpty)
          EmptyWidget(
            title: LocaleKeys.contact_cleaner_no_rules_title.tr(),
            subTitle: LocaleKeys.contact_cleaner_no_rules_subtitle.tr(),
            padding: EdgeInsets.symmetric(vertical: context.height * 0.12),
          )
        else
          ...rules.map(
            (NormalizationRule rule) => _RuleCard(
              rule: rule,
              onEditPressed: () => onEditRulePressed(rule),
              onDeletePressed: () => onDeleteRulePressed(rule.id),
            ),
          ),
      ],
    );
  }

  String _actionLabel(CrossContactDuplicateAction action) {
    switch (action) {
      case CrossContactDuplicateAction.ignore:
        return LocaleKeys.contact_cleaner_cross_action_ignore.tr();
      case CrossContactDuplicateAction.mergeContacts:
        return LocaleKeys.contact_cleaner_cross_action_merge.tr();
      case CrossContactDuplicateAction.keepOneNumber:
        return LocaleKeys.contact_cleaner_cross_action_keep_one.tr();
    }
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.rule,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final NormalizationRule rule;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.sm.h),
      padding: EdgeInsets.symmetric(horizontal: context.insets.sm.w),
      child: AdaptiveExpansionTile(
        title: Text(
          localizedContactCleanerRuleLabel(rule),
          style: context.textStyles.titleMedium.copyWith(
            color: context.colors.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          LocaleKeys.contact_cleaner_rule_country_code.tr(
            namedArgs: {'code': rule.canonicalCountryCode},
          ),
        ),
        trailing: AdaptivePopupMenuButton.widget<String>(
          items: [
            AdaptivePopupMenuItem(
              label: LocaleKeys.contact_cleaner_rule_update.tr(),
              icon: Icons.edit_outlined,
              value: 'edit',
            ),
            const AdaptivePopupMenuDivider(),
            AdaptivePopupMenuItem(
              label: LocaleKeys.contact_cleaner_delete_rule_action.tr(),
              icon: Icons.delete_outline,
              value: 'delete',
            ),
          ],
          onSelected: (int index, AdaptivePopupMenuItem<String> item) {
            if (item.value == 'edit') {
              onEditPressed();
            } else if (item.value == 'delete') {
              onDeletePressed();
            }
          },
          child: Icon(Icons.more_horiz, color: context.colors.onSecondary),
        ),
        childrenPadding: EdgeInsets.only(
          left: context.insets.sm.w,
          right: context.insets.sm.w,
          bottom: context.insets.md.h,
        ),
        children: [
          Wrap(
            spacing: context.insets.sm.w,
            runSpacing: context.insets.sm.h,
            children: [
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_rule_length.tr(
                  namedArgs: {'length': '${rule.expectedLength}'},
                ),
              ),
              ContactCleanerTag(
                label: rule.removeTrunkPrefix
                    ? LocaleKeys.contact_cleaner_rule_remove_prefix.tr(
                        namedArgs: {'prefix': rule.trunkPrefix},
                      )
                    : LocaleKeys.contact_cleaner_rule_no_prefix_removal.tr(),
                backgroundColor: rule.removeTrunkPrefix
                    ? context.colors.brand10Color
                    : context.colors.secondary,
                textColor: rule.removeTrunkPrefix
                    ? context.colors.primary
                    : context.colors.onPrimaryContainer,
              ),
            ],
          ),
          SizedBox(height: context.insets.sm.h),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_rule_matching_prefixes.tr(),
            value: rule.prefixes.isEmpty
                ? LocaleKeys.contact_cleaner_rule_any_prefix.tr()
                : rule.prefixes.join(', '),
          ),
        ],
      ),
    );
  }
}
