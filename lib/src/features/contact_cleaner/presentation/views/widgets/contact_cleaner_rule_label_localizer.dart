import 'package:easy_localization/easy_localization.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';

String localizedContactCleanerRuleLabel(NormalizationRule rule) {
  switch (rule.id) {
    case 'sa_mobile_10':
      return LocaleKeys.contact_cleaner_default_rule_sa_mobile.tr();
    case 'ye_mobile_9':
      return LocaleKeys.contact_cleaner_default_rule_ye_mobile.tr();
    default:
      return rule.label;
  }
}
