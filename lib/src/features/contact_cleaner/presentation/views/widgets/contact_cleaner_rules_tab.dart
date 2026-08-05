// ignore_for_file: lines_longer_than_80_chars

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
              _OptionTile(
                title: LocaleKeys.contact_cleaner_option_normalize_title.tr(),
                subtitle: LocaleKeys.contact_cleaner_option_normalize_subtitle
                    .tr(),
                value: options.normalizeNumbers,
                onChanged: onNormalizeChanged,
              ),
              SizedBox(height: context.insets.sm.h),
              _OptionTile(
                title: LocaleKeys.contact_cleaner_option_within_contact_title
                    .tr(),
                subtitle: LocaleKeys
                    .contact_cleaner_option_within_contact_subtitle
                    .tr(),
                value: options.removeDuplicatesWithinContact,
                onChanged: onWithinContactChanged,
              ),
              SizedBox(height: context.insets.md.h),
              DropdownButtonFormField<CrossContactDuplicateAction>(
                value: options.crossContactAction,
                decoration: InputDecoration(
                  labelText: LocaleKeys
                      .contact_cleaner_cross_contact_action_label
                      .tr(),
                ),
                items: CrossContactDuplicateAction.values
                    .map(
                      (CrossContactDuplicateAction action) =>
                          DropdownMenuItem<CrossContactDuplicateAction>(
                            value: action,
                            child: TextWidget(_actionLabel(action)),
                          ),
                    )
                    .toList(),
                onChanged: (CrossContactDuplicateAction? value) {
                  if (value != null) {
                    onCrossContactChanged(value);
                  }
                },
              ),
              SizedBox(height: context.insets.md.h),
              ButtonProgressStateWidget(
                text: LocaleKeys.contact_cleaner_enable_auto_preset.tr(),
                marginVertical: 0,
                defaultColor: context.colors.secondary,
                colorText: context.colors.onPrimaryContainer,
                onPressed: onAutoCleanPressed,
              ),
            ],
          ),
        ),
        SizedBox(height: context.insets.md.h),
        ButtonProgressStateWidget(
          text: LocaleKeys.contact_cleaner_add_rule.tr(),
          marginVertical: 0,
          defaultColor: context.colors.brandColor,
          colorText: context.colors.white,
          onPressed: onAddRulePressed,
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

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rm),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.insets.sm.w,
          vertical: context.insets.sm.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title,
                    style: context.textStyles.bodyLarge.copyWith(
                      color: context.colors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.insets.sm.h),
                  TextWidget(
                    subtitle,
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeColor: context.colors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  localizedContactCleanerRuleLabel(rule),
                  style: context.textStyles.titleMedium.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEditPressed,
                icon: Icon(Icons.edit_outlined, color: context.colors.primary),
              ),
              IconButton(
                onPressed: onDeletePressed,
                icon: Icon(Icons.delete_outline, color: context.colors.error),
              ),
            ],
          ),
          SizedBox(height: context.insets.md.h),
          Wrap(
            spacing: context.insets.sm.w,
            runSpacing: context.insets.sm.h,
            children: [
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_rule_length.tr(
                  namedArgs: {'length': '${rule.expectedLength}'},
                ),
                backgroundColor: context.colors.secondary,
              ),
              ContactCleanerTag(
                label: LocaleKeys.contact_cleaner_rule_country_code.tr(
                  namedArgs: {'code': rule.canonicalCountryCode},
                ),
                backgroundColor: context.colors.brand10Color,
                textColor: context.colors.primary,
              ),
              ContactCleanerTag(
                label: rule.removeTrunkPrefix
                    ? LocaleKeys.contact_cleaner_rule_remove_prefix.tr(
                        namedArgs: {'prefix': rule.trunkPrefix},
                      )
                    : LocaleKeys.contact_cleaner_rule_no_prefix_removal.tr(),
                backgroundColor: rule.removeTrunkPrefix
                    ? context.colors.primaryFixedLight
                    : context.colors.secondary,
                textColor: rule.removeTrunkPrefix
                    ? context.colors.primaryFixed
                    : context.colors.onPrimaryContainer,
              ),
            ],
          ),
          SizedBox(height: context.insets.md.h),
          ContactCleanerLabeledValue(
            label: LocaleKeys.contact_cleaner_rule_matching_prefixes.tr(),
            value: rule.prefixes.isEmpty
                ? LocaleKeys.contact_cleaner_rule_any_prefix.tr()
                : rule.prefixes.join(', '),
            backgroundColor: context.colors.secondary,
          ),
        ],
      ),
    );
  }
}
