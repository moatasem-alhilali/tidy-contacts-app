// Rule editor built entirely on adaptive_platform_ui form components:
// AdaptiveFormSection groups the fields, AdaptiveTextFormField handles input
// and validation, AdaptiveSwitch toggles trunk-prefix removal.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelController;
  late final TextEditingController _lengthController;
  late final TextEditingController _prefixesController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _trunkPrefixController;
  late bool _removeTrunkPrefix;

  bool get _isEditing => widget.initialRule != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: _isEditing
          ? localizedContactCleanerRuleLabel(widget.initialRule!)
          : '',
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int expectedLength = int.parse(_lengthController.text.trim());
    final List<String> prefixes = _prefixesController.text
        .split(',')
        .map((String prefix) => prefix.trim())
        .where((String prefix) => prefix.isNotEmpty)
        .toList();

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
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(kGapMd, kGapMd, kGapMd, 0),
              child: Text(
                _isEditing
                    ? LocaleKeys.contact_cleaner_edit_rule_title.tr()
                    : LocaleKeys.contact_cleaner_add_rule_title.tr(),
                style: tt.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AdaptiveFormSection.insetGrouped(
              header: Text(LocaleKeys.contact_cleaner_rule_example.tr()),
              children: [
                AdaptiveTextFormField(
                  controller: _labelController,
                  placeholder: LocaleKeys.contact_cleaner_rule_name_hint.tr(),
                  prefixIcon: const Icon(Icons.label_outline),
                  textCapitalization: TextCapitalization.words,
                  validator: _requiredValidator,
                ),
                AdaptiveTextFormField(
                  controller: _lengthController,
                  placeholder: LocaleKeys
                      .contact_cleaner_rule_expected_length_hint
                      .tr(),
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.tag),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    final int? parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return LocaleKeys.contact_cleaner_rule_validation_error
                          .tr();
                    }
                    return null;
                  },
                ),
                AdaptiveTextFormField(
                  controller: _countryCodeController,
                  placeholder: LocaleKeys.contact_cleaner_rule_country_code_hint
                      .tr(),
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.public),
                  validator: _requiredValidator,
                ),
                AdaptiveTextFormField(
                  controller: _prefixesController,
                  placeholder: LocaleKeys.contact_cleaner_rule_prefixes_hint
                      .tr(),
                  prefixIcon: const Icon(Icons.dialpad),
                ),
              ],
            ),
            AdaptiveFormSection.insetGrouped(
              children: [
                AdaptiveListTile(
                  title: Text(
                    LocaleKeys.contact_cleaner_rule_remove_local_prefix.tr(),
                  ),
                  trailing: AdaptiveSwitch(
                    value: _removeTrunkPrefix,
                    onChanged: (bool value) =>
                        setState(() => _removeTrunkPrefix = value),
                  ),
                ),
                if (_removeTrunkPrefix)
                  AdaptiveTextFormField(
                    controller: _trunkPrefixController,
                    placeholder: LocaleKeys
                        .contact_cleaner_rule_local_prefix_hint
                        .tr(),
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.filter_1),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(kGapMd),
              child: SizedBox(
                width: double.infinity,
                child: AdaptiveButton(
                  onPressed: _submit,
                  size: AdaptiveButtonSize.large,
                  label: _isEditing
                      ? LocaleKeys.contact_cleaner_rule_update.tr()
                      : LocaleKeys.contact_cleaner_rule_save.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.contact_cleaner_rule_validation_error.tr();
    }
    return null;
  }
}
