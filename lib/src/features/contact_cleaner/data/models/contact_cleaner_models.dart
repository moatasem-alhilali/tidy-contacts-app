// ignore_for_file: omit_local_variable_types, package_api_docs
// ignore_for_file: prefer_constructors_over_static_methods

enum CrossContactDuplicateAction { ignore, mergeContacts, keepOneNumber }

class CleanupOptions {
  const CleanupOptions({
    this.normalizeNumbers = true,
    this.removeDuplicatesWithinContact = true,
    this.crossContactAction = CrossContactDuplicateAction.mergeContacts,
  });

  final bool normalizeNumbers;
  final bool removeDuplicatesWithinContact;
  final CrossContactDuplicateAction crossContactAction;

  CleanupOptions copyWith({
    bool? normalizeNumbers,
    bool? removeDuplicatesWithinContact,
    CrossContactDuplicateAction? crossContactAction,
  }) {
    return CleanupOptions(
      normalizeNumbers: normalizeNumbers ?? this.normalizeNumbers,
      removeDuplicatesWithinContact:
          removeDuplicatesWithinContact ?? this.removeDuplicatesWithinContact,
      crossContactAction: crossContactAction ?? this.crossContactAction,
    );
  }
}

class NormalizationRule {
  const NormalizationRule({
    required this.id,
    required this.label,
    required this.expectedLength,
    required this.prefixes,
    required this.countryCode,
    this.removeTrunkPrefix = false,
    this.trunkPrefix = '0',
  });

  final String id;
  final String label;
  final int expectedLength;
  final List<String> prefixes;
  final String countryCode;
  final bool removeTrunkPrefix;
  final String trunkPrefix;

  String get canonicalCountryCode {
    final String raw = countryCode.trim();
    if (raw.startsWith('+')) {
      return raw;
    }
    if (raw.startsWith('00')) {
      return '+${raw.substring(2)}';
    }
    return '+$raw';
  }

  bool matches(String digits) {
    if (digits.length != expectedLength) {
      return false;
    }
    if (prefixes.isEmpty) {
      return true;
    }
    return prefixes.any(digits.startsWith);
  }

  String apply(String digits) {
    String nationalNumber = digits;
    if (removeTrunkPrefix &&
        trunkPrefix.isNotEmpty &&
        nationalNumber.startsWith(trunkPrefix)) {
      nationalNumber = nationalNumber.substring(trunkPrefix.length);
    }
    return '$canonicalCountryCode$nationalNumber';
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'label': label,
      'expectedLength': expectedLength,
      'prefixes': prefixes,
      'countryCode': countryCode,
      'removeTrunkPrefix': removeTrunkPrefix,
      'trunkPrefix': trunkPrefix,
    };
  }

  static NormalizationRule fromMap(Map<Object?, Object?> map) {
    return NormalizationRule(
      id: map['id']! as String,
      label: map['label']! as String,
      expectedLength: map['expectedLength']! as int,
      prefixes: (map['prefixes']! as List<Object?>).cast<String>(),
      countryCode: map['countryCode']! as String,
      removeTrunkPrefix: map['removeTrunkPrefix']! as bool,
      trunkPrefix: map['trunkPrefix']! as String,
    );
  }
}

class PhoneEntrySnapshot {
  const PhoneEntrySnapshot({required this.index, required this.originalNumber});

  final int index;
  final String originalNumber;

  Map<String, Object?> toMap() {
    return <String, Object?>{'index': index, 'originalNumber': originalNumber};
  }

  static PhoneEntrySnapshot fromMap(Map<Object?, Object?> map) {
    return PhoneEntrySnapshot(
      index: map['index']! as int,
      originalNumber: map['originalNumber']! as String,
    );
  }
}

class ContactSnapshot {
  const ContactSnapshot({
    required this.id,
    required this.displayName,
    required this.phones,
  });

  final String id;
  final String displayName;
  final List<PhoneEntrySnapshot> phones;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'displayName': displayName,
      'phones': phones
          .map((PhoneEntrySnapshot phone) => phone.toMap())
          .toList(),
    };
  }

  static ContactSnapshot fromMap(Map<Object?, Object?> map) {
    return ContactSnapshot(
      id: map['id']! as String,
      displayName: map['displayName']! as String,
      phones: (map['phones']! as List<Object?>)
          .map(
            (Object? value) =>
                PhoneEntrySnapshot.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
    );
  }
}

class ContactAnalysisRequest {
  const ContactAnalysisRequest({required this.contacts, required this.rules});

  final List<ContactSnapshot> contacts;
  final List<NormalizationRule> rules;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'contacts': contacts
          .map((ContactSnapshot contact) => contact.toMap())
          .toList(),
      'rules': rules.map((NormalizationRule rule) => rule.toMap()).toList(),
    };
  }

  static ContactAnalysisRequest fromMap(Map<Object?, Object?> map) {
    return ContactAnalysisRequest(
      contacts: (map['contacts']! as List<Object?>)
          .map(
            (Object? value) =>
                ContactSnapshot.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
      rules: (map['rules']! as List<Object?>)
          .map(
            (Object? value) =>
                NormalizationRule.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
    );
  }
}

class AnalyzedPhoneNumber {
  const AnalyzedPhoneNumber({
    required this.contactId,
    required this.contactName,
    required this.entryIndex,
    required this.originalNumber,
    required this.canonicalInput,
    required this.comparisonKey,
    required this.hasFormattingNoise,
    required this.hadArabicDigits,
    required this.hadInternationalPrefix,
    required this.isMissingCountryCode,
    required this.isUnmatchedLocal,
    required this.isInvalidLength,
    required this.wasCorrected,
    this.matchedRuleId,
    this.normalizedNumber,
  });

  final String contactId;
  final String contactName;
  final int entryIndex;
  final String originalNumber;
  final String canonicalInput;
  final String comparisonKey;
  final bool hasFormattingNoise;
  final bool hadArabicDigits;
  final bool hadInternationalPrefix;
  final bool isMissingCountryCode;
  final bool isUnmatchedLocal;
  final bool isInvalidLength;
  final bool wasCorrected;
  final String? matchedRuleId;
  final String? normalizedNumber;

  bool get hasAnyIssue {
    return hasFormattingNoise ||
        isMissingCountryCode ||
        isUnmatchedLocal ||
        isInvalidLength;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'contactId': contactId,
      'contactName': contactName,
      'entryIndex': entryIndex,
      'originalNumber': originalNumber,
      'canonicalInput': canonicalInput,
      'comparisonKey': comparisonKey,
      'hasFormattingNoise': hasFormattingNoise,
      'hadArabicDigits': hadArabicDigits,
      'hadInternationalPrefix': hadInternationalPrefix,
      'isMissingCountryCode': isMissingCountryCode,
      'isUnmatchedLocal': isUnmatchedLocal,
      'isInvalidLength': isInvalidLength,
      'wasCorrected': wasCorrected,
      'matchedRuleId': matchedRuleId,
      'normalizedNumber': normalizedNumber,
    };
  }

  static AnalyzedPhoneNumber fromMap(Map<Object?, Object?> map) {
    return AnalyzedPhoneNumber(
      contactId: map['contactId']! as String,
      contactName: map['contactName']! as String,
      entryIndex: map['entryIndex']! as int,
      originalNumber: map['originalNumber']! as String,
      canonicalInput: map['canonicalInput']! as String,
      comparisonKey: map['comparisonKey']! as String,
      hasFormattingNoise: map['hasFormattingNoise']! as bool,
      hadArabicDigits: map['hadArabicDigits']! as bool,
      hadInternationalPrefix: map['hadInternationalPrefix']! as bool,
      isMissingCountryCode: map['isMissingCountryCode']! as bool,
      isUnmatchedLocal: map['isUnmatchedLocal']! as bool,
      isInvalidLength: map['isInvalidLength']! as bool,
      wasCorrected: map['wasCorrected']! as bool,
      matchedRuleId: map['matchedRuleId'] as String?,
      normalizedNumber: map['normalizedNumber'] as String?,
    );
  }
}

class DuplicateOccurrence {
  const DuplicateOccurrence({
    required this.contactId,
    required this.contactName,
    required this.entryIndex,
    required this.originalNumber,
    required this.canonicalInput,
    this.normalizedNumber,
  });

  final String contactId;
  final String contactName;
  final int entryIndex;
  final String originalNumber;
  final String canonicalInput;
  final String? normalizedNumber;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'contactId': contactId,
      'contactName': contactName,
      'entryIndex': entryIndex,
      'originalNumber': originalNumber,
      'canonicalInput': canonicalInput,
      'normalizedNumber': normalizedNumber,
    };
  }

  static DuplicateOccurrence fromMap(Map<Object?, Object?> map) {
    return DuplicateOccurrence(
      contactId: map['contactId']! as String,
      contactName: map['contactName']! as String,
      entryIndex: map['entryIndex']! as int,
      originalNumber: map['originalNumber']! as String,
      canonicalInput: map['canonicalInput']! as String,
      normalizedNumber: map['normalizedNumber'] as String?,
    );
  }
}

class DuplicateGroup {
  const DuplicateGroup({
    required this.key,
    required this.occurrences,
    required this.crossesContacts,
    required this.withinSingleContact,
    this.displayNumber,
  });

  final String key;
  final String? displayNumber;
  final List<DuplicateOccurrence> occurrences;
  final bool crossesContacts;
  final bool withinSingleContact;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'key': key,
      'displayNumber': displayNumber,
      'occurrences': occurrences
          .map((DuplicateOccurrence occurrence) => occurrence.toMap())
          .toList(),
      'crossesContacts': crossesContacts,
      'withinSingleContact': withinSingleContact,
    };
  }

  static DuplicateGroup fromMap(Map<Object?, Object?> map) {
    return DuplicateGroup(
      key: map['key']! as String,
      displayNumber: map['displayNumber'] as String?,
      occurrences: (map['occurrences']! as List<Object?>)
          .map(
            (Object? value) =>
                DuplicateOccurrence.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
      crossesContacts: map['crossesContacts']! as bool,
      withinSingleContact: map['withinSingleContact']! as bool,
    );
  }
}

class AnalysisStats {
  const AnalysisStats({
    required this.totalContacts,
    required this.totalNumbers,
    required this.missingCountryCode,
    required this.duplicateEntries,
    required this.duplicateGroups,
    required this.correctedNumbers,
    required this.invalidNumbers,
    required this.unmatchedLocalNumbers,
    required this.formattingIssues,
  });

  final int totalContacts;
  final int totalNumbers;
  final int missingCountryCode;
  final int duplicateEntries;
  final int duplicateGroups;
  final int correctedNumbers;
  final int invalidNumbers;
  final int unmatchedLocalNumbers;
  final int formattingIssues;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'totalContacts': totalContacts,
      'totalNumbers': totalNumbers,
      'missingCountryCode': missingCountryCode,
      'duplicateEntries': duplicateEntries,
      'duplicateGroups': duplicateGroups,
      'correctedNumbers': correctedNumbers,
      'invalidNumbers': invalidNumbers,
      'unmatchedLocalNumbers': unmatchedLocalNumbers,
      'formattingIssues': formattingIssues,
    };
  }

  static AnalysisStats fromMap(Map<Object?, Object?> map) {
    return AnalysisStats(
      totalContacts: map['totalContacts']! as int,
      totalNumbers: map['totalNumbers']! as int,
      missingCountryCode: map['missingCountryCode']! as int,
      duplicateEntries: map['duplicateEntries']! as int,
      duplicateGroups: map['duplicateGroups']! as int,
      correctedNumbers: map['correctedNumbers']! as int,
      invalidNumbers: map['invalidNumbers']! as int,
      unmatchedLocalNumbers: map['unmatchedLocalNumbers']! as int,
      formattingIssues: map['formattingIssues']! as int,
    );
  }
}

class ContactAnalysisResult {
  const ContactAnalysisResult({
    required this.contacts,
    required this.analyzedPhones,
    required this.duplicateGroups,
    required this.stats,
  });

  final List<ContactSnapshot> contacts;
  final List<AnalyzedPhoneNumber> analyzedPhones;
  final List<DuplicateGroup> duplicateGroups;
  final AnalysisStats stats;

  List<DuplicateGroup> get crossContactDuplicates {
    return duplicateGroups
        .where((DuplicateGroup group) => group.crossesContacts)
        .toList();
  }

  List<DuplicateGroup> get withinContactDuplicates {
    return duplicateGroups
        .where((DuplicateGroup group) => group.withinSingleContact)
        .toList();
  }

  List<AnalyzedPhoneNumber> get issuePhones {
    return analyzedPhones
        .where((AnalyzedPhoneNumber phone) => phone.hasAnyIssue)
        .toList();
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'contacts': contacts
          .map((ContactSnapshot contact) => contact.toMap())
          .toList(),
      'analyzedPhones': analyzedPhones
          .map((AnalyzedPhoneNumber phone) => phone.toMap())
          .toList(),
      'duplicateGroups': duplicateGroups
          .map((DuplicateGroup group) => group.toMap())
          .toList(),
      'stats': stats.toMap(),
    };
  }

  static ContactAnalysisResult fromMap(Map<Object?, Object?> map) {
    return ContactAnalysisResult(
      contacts: (map['contacts']! as List<Object?>)
          .map(
            (Object? value) =>
                ContactSnapshot.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
      analyzedPhones: (map['analyzedPhones']! as List<Object?>)
          .map(
            (Object? value) =>
                AnalyzedPhoneNumber.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
      duplicateGroups: (map['duplicateGroups']! as List<Object?>)
          .map(
            (Object? value) =>
                DuplicateGroup.fromMap(value! as Map<Object?, Object?>),
          )
          .toList(),
      stats: AnalysisStats.fromMap(map['stats']! as Map<Object?, Object?>),
    );
  }
}

class PlannedPhoneChange {
  const PlannedPhoneChange({
    required this.entryIndex,
    required this.originalNumber,
    required this.deduplicationKey,
    required this.keep,
    this.replacementNumber,
  });

  final int entryIndex;
  final String originalNumber;
  final String deduplicationKey;
  final bool keep;
  final String? replacementNumber;

  bool get needsReplacement {
    return replacementNumber != null && replacementNumber != originalNumber;
  }
}

class ContactCleanupPlanEntry {
  const ContactCleanupPlanEntry({
    required this.contactId,
    required this.contactName,
    required this.phoneChanges,
  });

  final String contactId;
  final String contactName;
  final List<PlannedPhoneChange> phoneChanges;

  int get numbersRemoved {
    return phoneChanges
        .where((PlannedPhoneChange change) => !change.keep)
        .length;
  }

  int get numbersNormalized {
    return phoneChanges
        .where(
          (PlannedPhoneChange change) => change.keep && change.needsReplacement,
        )
        .length;
  }

  bool get hasChanges {
    return numbersRemoved > 0 || numbersNormalized > 0;
  }
}

class MergePlan {
  const MergePlan({
    required this.primaryContactId,
    required this.primaryContactName,
    required this.contactIds,
    required this.contactNames,
  });

  final String primaryContactId;
  final String primaryContactName;
  final List<String> contactIds;
  final List<String> contactNames;

  List<String> get secondaryContactIds {
    return contactIds
        .where((String contactId) => contactId != primaryContactId)
        .toList();
  }
}

class CleanupPlan {
  const CleanupPlan({
    required this.contactPlans,
    required this.mergePlans,
    required this.mergedDuplicateNumbers,
  });

  final List<ContactCleanupPlanEntry> contactPlans;
  final List<MergePlan> mergePlans;
  final int mergedDuplicateNumbers;

  bool get hasChanges {
    return contactPlans.any(
          (ContactCleanupPlanEntry plan) => plan.hasChanges,
        ) ||
        mergePlans.isNotEmpty;
  }

  int get contactsToDelete {
    return mergePlans.fold<int>(
      0,
      (int total, MergePlan plan) => total + plan.secondaryContactIds.length,
    );
  }

  int get contactsToUpdate {
    final Set<String> mergedContactIds = mergePlans
        .expand((MergePlan plan) => plan.contactIds)
        .toSet();
    final int standaloneUpdates = contactPlans
        .where(
          (ContactCleanupPlanEntry plan) =>
              plan.hasChanges && !mergedContactIds.contains(plan.contactId),
        )
        .length;
    return standaloneUpdates + mergePlans.length;
  }

  int get numbersNormalized {
    return contactPlans.fold<int>(
      0,
      (int total, ContactCleanupPlanEntry plan) =>
          total + plan.numbersNormalized,
    );
  }

  int get numbersRemoved {
    final int directRemovals = contactPlans.fold<int>(
      0,
      (int total, ContactCleanupPlanEntry plan) => total + plan.numbersRemoved,
    );
    return directRemovals + mergedDuplicateNumbers;
  }

  ContactCleanupPlanEntry? findContactPlan(String contactId) {
    for (final ContactCleanupPlanEntry plan in contactPlans) {
      if (plan.contactId == contactId) {
        return plan;
      }
    }
    return null;
  }
}
