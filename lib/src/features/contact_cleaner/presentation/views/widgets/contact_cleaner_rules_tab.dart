// Rules & options tab.
// Options -> AdaptiveListTile + AdaptiveSwitch
// Cross-contact strategy -> AdaptiveSegmentedControl
// Actions -> AdaptiveButton
// Each rule -> AdaptiveExpansionTile + AdaptivePopupMenuButton

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: kGapXl),
      children: [
        ContactCleanerPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.contact_cleaner_rules_title.tr(),
                style: tt.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: kGapSm),
              Text(
                LocaleKeys.contact_cleaner_rules_subtitle.tr(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: kGapMd),
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
              const SizedBox(height: kGapMd),
              Text(
                LocaleKeys.contact_cleaner_cross_contact_action_label.tr(),
                style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: kGapSm),
              AdaptiveSegmentedControl(
                labels: _crossActions
                    .map((CrossContactDuplicateAction a) => _actionLabel(a))
                    .toList(),
                selectedIndex: _crossActions.indexOf(options.crossContactAction),
                onValueChanged: (int index) =>
                    onCrossContactChanged(_crossActions[index]),
              ),
              const SizedBox(height: kGapMd),
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
        const SizedBox(height: kGapMd),
        SizedBox(
          width: double.infinity,
          child: AdaptiveButton.child(
            onPressed: onAddRulePressed,
            size: AdaptiveButtonSize.large,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 18),
                const SizedBox(width: kGapSm),
                Text(LocaleKeys.contact_cleaner_add_rule.tr()),
              ],
            ),
          ),
        ),
        const SizedBox(height: kGapMd),
        if (rules.isEmpty)
          ContactCleanerEmptyState(
            icon: Icons.rule_folder_outlined,
            title: LocaleKeys.contact_cleaner_no_rules_title.tr(),
            subtitle: LocaleKeys.contact_cleaner_no_rules_subtitle.tr(),
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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return ContactCleanerPanel(
      margin: const EdgeInsets.only(bottom: kGapSm),
      padding: const EdgeInsets.symmetric(horizontal: kGapSm),
      child: AdaptiveExpansionTile(
        title: Text(
          localizedContactCleanerRuleLabel(rule),
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
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
          child: Icon(Icons.more_horiz, color: cs.onSurfaceVariant),
        ),
        childrenPadding: const EdgeInsets.only(bottom: kGapMd),
        children: [
          Wrap(
            spacing: kGapSm,
            runSpacing: kGapSm,
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
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
                textColor: rule.removeTrunkPrefix
                    ? cs.onPrimaryContainer
                    : cs.onSurface,
              ),
            ],
          ),
          const SizedBox(height: kGapSm),
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
