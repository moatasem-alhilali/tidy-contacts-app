// Rules — redesigned as a CONTROL PANEL:
//   • options as SettingRows (coloured glyph + switch)
//   • cross-contact strategy as an AdaptiveSegmentedControl
//   • rules as accent-striped records with an AdaptivePopupMenuButton

import 'dart:ui' as ui;

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_design.dart';
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

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: kGapXl),
      children: [
        _SectionLabel(LocaleKeys.contact_cleaner_rules_title.tr()),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: kRadiusCard,
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: kGapMd,
            vertical: kGapSm,
          ),
          child: Column(
            children: [
              SettingRow(
                icon: Icons.public,
                iconColor: cs.primary,
                title: LocaleKeys.contact_cleaner_option_normalize_title.tr(),
                subtitle: LocaleKeys.contact_cleaner_option_normalize_subtitle
                    .tr(),
                trailing: AdaptiveSwitch(
                  value: options.normalizeNumbers,
                  onChanged: onNormalizeChanged,
                ),
              ),
              Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
              SettingRow(
                icon: Icons.filter_none,
                iconColor: cs.tertiary,
                title: LocaleKeys.contact_cleaner_option_within_contact_title
                    .tr(),
                subtitle: LocaleKeys
                    .contact_cleaner_option_within_contact_subtitle
                    .tr(),
                trailing: AdaptiveSwitch(
                  value: options.removeDuplicatesWithinContact,
                  onChanged: onWithinContactChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kGapLg),
        _SectionLabel(
          LocaleKeys.contact_cleaner_cross_contact_action_label.tr(),
        ),
        AdaptiveSegmentedControl(
          labels: _crossActions
              .map((CrossContactDuplicateAction a) => _actionLabel(a))
              .toList(),
          selectedIndex: _crossActions.indexOf(options.crossContactAction),
          onValueChanged: (int index) =>
              onCrossContactChanged(_crossActions[index]),
        ),
        const SizedBox(height: kGapLg),
        Row(
          children: [
            Expanded(
              child: AdaptiveButton(
                onPressed: onAutoCleanPressed,
                style: AdaptiveButtonStyle.tinted,
                label: LocaleKeys.contact_cleaner_enable_auto_preset.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: kGapLg),
        Row(
          children: [
            _SectionLabel(LocaleKeys.contact_cleaner_tab_rules.tr()),
            const Spacer(),
            AdaptiveButton.child(
              onPressed: onAddRulePressed,
              style: AdaptiveButtonStyle.tinted,
              size: AdaptiveButtonSize.small,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 16),
                  const SizedBox(width: kGapXs),
                  Text(LocaleKeys.contact_cleaner_add_rule.tr()),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: kGapSm),
        if (rules.isEmpty)
          ContactCleanerEmptyState(
            icon: Icons.rule_folder_outlined,
            title: LocaleKeys.contact_cleaner_no_rules_title.tr(),
            subtitle: LocaleKeys.contact_cleaner_no_rules_subtitle.tr(),
          )
        else
          ...rules.map(
            (NormalizationRule rule) => _RuleRecord(
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: kGapSm, top: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _RuleRecord extends StatelessWidget {
  const _RuleRecord({
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

    return AccentCard(
      accent: cs.primary,
      child: Padding(
        padding: const EdgeInsets.all(kGapMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kGapSm,
                    vertical: kGapXs,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: kRadiusPill,
                  ),
                  child: Text(
                    rule.canonicalCountryCode,
                    textDirection: ui.TextDirection.ltr,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: kGapSm),
                Expanded(
                  child: Text(
                    localizedContactCleanerRuleLabel(rule),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                AdaptivePopupMenuButton.widget<String>(
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
              ],
            ),
            const SizedBox(height: kGapMd),
            Wrap(
              spacing: kGapSm,
              runSpacing: kGapXs,
              children: [
                ContactCleanerTag(
                  icon: Icons.straighten,
                  label: LocaleKeys.contact_cleaner_rule_length.tr(
                    namedArgs: {'length': '${rule.expectedLength}'},
                  ),
                ),
                ContactCleanerTag(
                  icon: rule.removeTrunkPrefix
                      ? Icons.content_cut
                      : Icons.block,
                  label: rule.removeTrunkPrefix
                      ? LocaleKeys.contact_cleaner_rule_remove_prefix.tr(
                          namedArgs: {'prefix': rule.trunkPrefix},
                        )
                      : LocaleKeys.contact_cleaner_rule_no_prefix_removal.tr(),
                  backgroundColor: rule.removeTrunkPrefix
                      ? cs.tertiaryContainer
                      : cs.surfaceContainerHighest,
                  textColor: rule.removeTrunkPrefix
                      ? cs.onTertiaryContainer
                      : cs.onSurfaceVariant,
                ),
                ContactCleanerTag(
                  icon: Icons.dialpad,
                  label: rule.prefixes.isEmpty
                      ? LocaleKeys.contact_cleaner_rule_any_prefix.tr()
                      : rule.prefixes.join(', '),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
