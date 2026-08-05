// ignore_for_file: omit_local_variable_types

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_rule_label_localizer.dart';

class ContactCleanerRuleFormSheet extends StatefulWidget {
  const ContactCleanerRuleFormSheet({
    required this.onSubmitted,
    super.key,
    this.initialRule,
  });

  final NormalizationRule? initialRule;
  final ValueChanged<NormalizationRule> onSubmitted;

  @override
  State<ContactCleanerRuleFormSheet> createState() =>
      _ContactCleanerRuleFormSheetState();
}

class _ContactCleanerRuleFormSheetState
    extends State<ContactCleanerRuleFormSheet> {
  late final TextEditingController _labelController;
  late final TextEditingController _lengthController;
  late final TextEditingController _prefixesController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _trunkPrefixController;
  late bool _removeTrunkPrefix;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.initialRule == null
          ? ''
          : localizedContactCleanerRuleLabel(widget.initialRule!),
    );
    _lengthController = TextEditingController(
      text: widget.initialRule?.expectedLength.toString() ?? '',
    );
    _prefixesController = TextEditingController(
      text: widget.initialRule?.prefixes.join(', ') ?? '',
    );
    _countryCodeController = TextEditingController(
      text: widget.initialRule?.countryCode ?? '',
    );
    _trunkPrefixController = TextEditingController(
      text: widget.initialRule?.trunkPrefix ?? '0',
    );
    _removeTrunkPrefix = widget.initialRule?.removeTrunkPrefix ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _lengthController.dispose();
    _prefixesController.dispose();
    _countryCodeController.dispose();
    _trunkPrefixController.dispose();
    super.dispose();
  }

  void _submit() {
    final int? expectedLength = int.tryParse(_lengthController.text.trim());
    final List<String> prefixes = _prefixesController.text
        .split(',')
        .map((String prefix) => prefix.trim())
        .where((String prefix) => prefix.isNotEmpty)
        .toList();

    if (_labelController.text.trim().isEmpty ||
        expectedLength == null ||
        expectedLength <= 0 ||
        _countryCodeController.text.trim().isEmpty) {
      context.showWarningSnackbar(
        LocaleKeys.contact_cleaner_rule_validation_error.tr(),
      );
      return;
    }

    widget.onSubmitted(
      NormalizationRule(
        id:
            widget.initialRule?.id ??
            'rule_${DateTime.now().microsecondsSinceEpoch}',
        label: _labelController.text.trim(),
        expectedLength: expectedLength,
        prefixes: prefixes,
        countryCode: _countryCodeController.text.trim(),
        removeTrunkPrefix: _removeTrunkPrefix,
        trunkPrefix: _trunkPrefixController.text.trim().isEmpty
            ? '0'
            : _trunkPrefixController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.insets.md.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            widget.initialRule == null
                ? LocaleKeys.contact_cleaner_add_rule_title.tr()
                : LocaleKeys.contact_cleaner_edit_rule_title.tr(),
            style: context.textStyles.titleMedium.copyWith(
              color: context.colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.insets.sm.h),
          ContactCleanerPanel(
            padding: EdgeInsets.all(context.insets.sm.w),
            color: context.colors.secondary,
            borderColor: context.colors.secondary,
            child: TextWidget(
              LocaleKeys.contact_cleaner_rule_example.tr(),
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
          ),
          SizedBox(height: context.insets.md.h),
          TextFormFieldWidget(
            controller: _labelController,
            labelText: LocaleKeys.contact_cleaner_rule_name.tr(),
            hintText: LocaleKeys.contact_cleaner_rule_name_hint.tr(),
          ),
          SizedBox(height: context.insets.md.h),
          TextFormFieldWidget(
            controller: _lengthController,
            labelText: LocaleKeys.contact_cleaner_rule_expected_length.tr(),
            hintText: LocaleKeys.contact_cleaner_rule_expected_length_hint.tr(),
            numberFormatter: true,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: context.insets.md.h),
          TextFormFieldWidget(
            controller: _prefixesController,
            labelText: LocaleKeys.contact_cleaner_rule_prefixes.tr(),
            hintText: LocaleKeys.contact_cleaner_rule_prefixes_hint.tr(),
          ),
          SizedBox(height: context.insets.md.h),
          TextFormFieldWidget(
            controller: _countryCodeController,
            labelText: LocaleKeys.contact_cleaner_rule_country_code_field.tr(),
            hintText: LocaleKeys.contact_cleaner_rule_country_code_hint.tr(),
            phoneFormatter: true,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: context.insets.sm.h),
          CheckboxListTile(
            value: _removeTrunkPrefix,
            onChanged: (bool? value) {
              setState(() {
                _removeTrunkPrefix = value ?? false;
              });
            },
            title: TextWidget(
              LocaleKeys.contact_cleaner_rule_remove_local_prefix.tr(),
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.onPrimaryContainer,
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          if (_removeTrunkPrefix) ...[
            SizedBox(height: context.insets.sm.h),
            TextFormFieldWidget(
              controller: _trunkPrefixController,
              labelText: LocaleKeys.contact_cleaner_rule_local_prefix.tr(),
              hintText: LocaleKeys.contact_cleaner_rule_local_prefix_hint.tr(),
            ),
          ],
          SizedBox(height: context.insets.lg.h),
          ButtonProgressStateWidget(
            text: widget.initialRule == null
                ? LocaleKeys.contact_cleaner_rule_save.tr()
                : LocaleKeys.contact_cleaner_rule_update.tr(),
            marginVertical: 0,
            defaultColor: context.colors.brandColor,
            colorText: context.colors.white,
            onPressed: _submit,
          ),
          SizedBox(height: context.insets.md.h),
        ],
      ),
    );
  }
}
