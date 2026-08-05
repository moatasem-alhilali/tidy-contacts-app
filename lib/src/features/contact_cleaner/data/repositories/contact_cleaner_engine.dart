// ignore_for_file: cascade_invocations, join_return_with_assignment
// ignore_for_file: lines_longer_than_80_chars, noop_primitive_operations
// ignore_for_file: omit_local_variable_types, package_api_docs

import 'package:collection/collection.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';

Map<String, Object?> analyzeContactsPayload(Map<Object?, Object?> rawPayload) {
  final ContactAnalysisRequest request = ContactAnalysisRequest.fromMap(
    rawPayload,
  );
  return ContactAnalysisEngine.analyze(request).toMap();
}

class ContactAnalysisEngine {
  static ContactAnalysisResult analyze(ContactAnalysisRequest request) {
    final List<AnalyzedPhoneNumber> analyzedPhones = <AnalyzedPhoneNumber>[];

    for (final ContactSnapshot contact in request.contacts) {
      for (final PhoneEntrySnapshot phone in contact.phones) {
        analyzedPhones.add(_analyzePhone(contact, phone, request.rules));
      }
    }

    final Map<String, List<DuplicateOccurrence>> groupedOccurrences =
        <String, List<DuplicateOccurrence>>{};
    for (final AnalyzedPhoneNumber phone in analyzedPhones) {
      if (phone.comparisonKey.isEmpty) {
        continue;
      }
      final List<DuplicateOccurrence> bucket = groupedOccurrences.putIfAbsent(
        phone.comparisonKey,
        () => <DuplicateOccurrence>[],
      );
      bucket.add(
        DuplicateOccurrence(
          contactId: phone.contactId,
          contactName: phone.contactName,
          entryIndex: phone.entryIndex,
          originalNumber: phone.originalNumber,
          canonicalInput: phone.canonicalInput,
          normalizedNumber: phone.normalizedNumber,
        ),
      );
    }

    final List<DuplicateGroup> duplicateGroups =
        groupedOccurrences.entries
            .where((MapEntry<String, List<DuplicateOccurrence>> entry) {
              return entry.value.length > 1;
            })
            .map((MapEntry<String, List<DuplicateOccurrence>> entry) {
              final Set<String> distinctContacts = entry.value
                  .map((DuplicateOccurrence occurrence) => occurrence.contactId)
                  .toSet();
              final Map<String, int> occurrencesPerContact = <String, int>{};
              for (final DuplicateOccurrence occurrence in entry.value) {
                occurrencesPerContact.update(
                  occurrence.contactId,
                  (int current) => current + 1,
                  ifAbsent: () => 1,
                );
              }
              final String? displayNumber = entry.value
                  .map(
                    (DuplicateOccurrence occurrence) =>
                        occurrence.normalizedNumber,
                  )
                  .firstWhereOrNull((String? normalized) => normalized != null);
              return DuplicateGroup(
                key: entry.key,
                displayNumber: displayNumber,
                occurrences: entry.value,
                crossesContacts: distinctContacts.length > 1,
                withinSingleContact: occurrencesPerContact.values.any(
                  (int count) => count > 1,
                ),
              );
            })
            .toList()
          ..sort(
            (DuplicateGroup left, DuplicateGroup right) =>
                right.occurrences.length.compareTo(left.occurrences.length),
          );

    final AnalysisStats stats = AnalysisStats(
      totalContacts: request.contacts.length,
      totalNumbers: analyzedPhones.length,
      missingCountryCode: analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.isMissingCountryCode)
          .length,
      duplicateEntries: duplicateGroups.fold<int>(
        0,
        (int total, DuplicateGroup group) =>
            total + group.occurrences.length - 1,
      ),
      duplicateGroups: duplicateGroups.length,
      correctedNumbers: analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.wasCorrected)
          .length,
      invalidNumbers: analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.isInvalidLength)
          .length,
      unmatchedLocalNumbers: analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.isUnmatchedLocal)
          .length,
      formattingIssues: analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.hasFormattingNoise)
          .length,
    );

    return ContactAnalysisResult(
      contacts: request.contacts,
      analyzedPhones: analyzedPhones,
      duplicateGroups: duplicateGroups,
      stats: stats,
    );
  }

  static AnalyzedPhoneNumber _analyzePhone(
    ContactSnapshot contact,
    PhoneEntrySnapshot phone,
    List<NormalizationRule> rules,
  ) {
    final String convertedDigits = _convertArabicDigits(phone.originalNumber);
    final String canonicalInput = _canonicalizeInput(convertedDigits);
    final String digitsOnly = _extractDigits(canonicalInput);
    final bool hadArabicDigits = convertedDigits != phone.originalNumber;
    final bool hasFormattingNoise =
        convertedDigits.trim() != canonicalInput &&
        phone.originalNumber.trim().isNotEmpty;
    final bool startsWithPlus = canonicalInput.startsWith('+');
    final bool startsWithDoubleZero =
        !startsWithPlus && canonicalInput.startsWith('00');

    String? normalizedNumber;
    String? matchedRuleId;
    bool hadEmbeddedCountryCode = false;
    if (startsWithPlus) {
      // Already international, e.g. +966512345678 -> +966512345678.
      normalizedNumber = digitsOnly.isEmpty ? null : '+$digitsOnly';
    } else if (startsWithDoubleZero) {
      // 00 international prefix, e.g. 00966512345678 -> +966512345678.
      final String stripped = digitsOnly.substring(2);
      normalizedNumber = stripped.isEmpty ? null : '+$stripped';
    } else if (digitsOnly.isNotEmpty) {
      // 1) Direct local match, e.g. 0512345678 (SA) / 771234567 (YE).
      final NormalizationRule? matchingRule = rules.firstWhereOrNull(
        (NormalizationRule rule) => rule.matches(digitsOnly),
      );
      if (matchingRule != null) {
        matchedRuleId = matchingRule.id;
        normalizedNumber = matchingRule.apply(digitsOnly);
      } else {
        // 2) The number may already embed a rule's country code but without a
        // leading '+' or '00', e.g. 966512345678 or 96777123456. Recognize it
        // only when the national remainder is valid for that rule, so we never
        // add a '+' to an ambiguous local number.
        for (final NormalizationRule rule in rules) {
          final String countryDigits = _extractDigits(rule.canonicalCountryCode);
          if (countryDigits.isEmpty ||
              !digitsOnly.startsWith(countryDigits) ||
              digitsOnly.length <= countryDigits.length) {
            continue;
          }
          final String national = digitsOnly.substring(countryDigits.length);
          final String localCandidate = rule.removeTrunkPrefix
              ? '${rule.trunkPrefix}$national'
              : national;
          if (rule.matches(localCandidate)) {
            matchedRuleId = rule.id;
            hadEmbeddedCountryCode = true;
            normalizedNumber = '+$countryDigits$national';
            break;
          }
        }
      }
    }

    final String comparisonKey = normalizedNumber ?? digitsOnly;
    final int digitLength = normalizedNumber == null
        ? digitsOnly.length
        : normalizedNumber.substring(1).length;
    final bool isInvalidLength =
        digitLength > 0 && (digitLength < 7 || digitLength > 15);
    final bool isMissingCountryCode =
        digitsOnly.isNotEmpty &&
        !startsWithPlus &&
        !startsWithDoubleZero &&
        !hadEmbeddedCountryCode;
    final bool isUnmatchedLocal = isMissingCountryCode && matchedRuleId == null;
    final bool wasCorrected =
        normalizedNumber != null && normalizedNumber != canonicalInput;

    return AnalyzedPhoneNumber(
      contactId: contact.id,
      contactName: contact.displayName,
      entryIndex: phone.index,
      originalNumber: phone.originalNumber,
      canonicalInput: canonicalInput,
      comparisonKey: comparisonKey,
      hasFormattingNoise: hasFormattingNoise,
      hadArabicDigits: hadArabicDigits,
      hadInternationalPrefix: startsWithPlus || startsWithDoubleZero,
      isMissingCountryCode: isMissingCountryCode,
      isUnmatchedLocal: isUnmatchedLocal,
      isInvalidLength: isInvalidLength,
      wasCorrected: wasCorrected,
      matchedRuleId: matchedRuleId,
      normalizedNumber: normalizedNumber,
    );
  }

  static String _convertArabicDigits(String input) {
    const Map<String, String> arabicDigits = <String, String>{
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };
    final StringBuffer buffer = StringBuffer();
    for (final int rune in input.runes) {
      final String character = String.fromCharCode(rune);
      buffer.write(arabicDigits[character] ?? character);
    }
    return buffer.toString();
  }

  static String _canonicalizeInput(String input) {
    final String trimmed = input.trim();
    final bool startsWithPlus = trimmed.startsWith('+');
    final StringBuffer digits = StringBuffer();
    for (final int rune in trimmed.runes) {
      final String character = String.fromCharCode(rune);
      if (_isAsciiDigit(character)) {
        digits.write(character);
      }
    }
    if (startsWithPlus && digits.isNotEmpty) {
      return '+${digits.toString()}';
    }
    return digits.toString();
  }

  static String _extractDigits(String input) {
    final StringBuffer digits = StringBuffer();
    for (final int rune in input.runes) {
      final String character = String.fromCharCode(rune);
      if (_isAsciiDigit(character)) {
        digits.write(character);
      }
    }
    return digits.toString();
  }

  static bool _isAsciiDigit(String input) {
    return input.codeUnitAt(0) >= 48 && input.codeUnitAt(0) <= 57;
  }
}

class ContactCleanupPlanner {
  static CleanupPlan build(
    ContactAnalysisResult analysis,
    CleanupOptions options,
  ) {
    final Map<String, ContactCleanupPlanEntry> planByContact =
        <String, ContactCleanupPlanEntry>{};
    final Map<String, AnalyzedPhoneNumber> phoneByKey =
        <String, AnalyzedPhoneNumber>{};

    for (final ContactSnapshot contact in analysis.contacts) {
      final List<PlannedPhoneChange> phoneChanges = contact.phones
          .map(
            (PhoneEntrySnapshot phone) => PlannedPhoneChange(
              entryIndex: phone.index,
              originalNumber: phone.originalNumber,
              deduplicationKey: '',
              keep: true,
            ),
          )
          .toList();
      planByContact[contact.id] = ContactCleanupPlanEntry(
        contactId: contact.id,
        contactName: contact.displayName,
        phoneChanges: phoneChanges,
      );
    }

    for (final AnalyzedPhoneNumber phone in analysis.analyzedPhones) {
      phoneByKey[_phoneKey(phone.contactId, phone.entryIndex)] = phone;
      final ContactCleanupPlanEntry contactPlan =
          planByContact[phone.contactId]!;
      final PlannedPhoneChange currentChange =
          contactPlan.phoneChanges[phone.entryIndex];
      contactPlan.phoneChanges[phone.entryIndex] = PlannedPhoneChange(
        entryIndex: currentChange.entryIndex,
        originalNumber: currentChange.originalNumber,
        deduplicationKey: phone.comparisonKey,
        keep: true,
        replacementNumber: options.normalizeNumbers
            ? phone.normalizedNumber
            : null,
      );
    }

    if (options.removeDuplicatesWithinContact) {
      final Map<String, List<AnalyzedPhoneNumber>> byContactAndKey = analysis
          .analyzedPhones
          .where((AnalyzedPhoneNumber phone) => phone.comparisonKey.isNotEmpty)
          .groupListsBy(
            (AnalyzedPhoneNumber phone) =>
                '${phone.contactId}::${phone.comparisonKey}',
          );

      for (final List<AnalyzedPhoneNumber> phones in byContactAndKey.values) {
        if (phones.length < 2) {
          continue;
        }
        final AnalyzedPhoneNumber preferred = _pickPreferredPhone(
          phones,
          planByContact,
        );
        for (final AnalyzedPhoneNumber phone in phones) {
          if (phone.entryIndex == preferred.entryIndex &&
              phone.contactId == preferred.contactId) {
            continue;
          }
          _markAsRemoved(planByContact, phone.contactId, phone.entryIndex);
        }
      }
    }

    final List<MergePlan> mergePlans;
    int mergedDuplicateNumbers = 0;

    switch (options.crossContactAction) {
      case CrossContactDuplicateAction.ignore:
        mergePlans = const <MergePlan>[];
      case CrossContactDuplicateAction.keepOneNumber:
        mergePlans = const <MergePlan>[];
        final List<DuplicateGroup> crossContactGroups = analysis.duplicateGroups
            .where((DuplicateGroup group) => group.crossesContacts)
            .toList();
        for (final DuplicateGroup group in crossContactGroups) {
          final List<AnalyzedPhoneNumber> activePhones = group.occurrences
              .map(
                (DuplicateOccurrence occurrence) =>
                    phoneByKey[_phoneKey(
                      occurrence.contactId,
                      occurrence.entryIndex,
                    )]!,
              )
              .where(
                (AnalyzedPhoneNumber phone) => planByContact[phone.contactId]!
                    .phoneChanges[phone.entryIndex]
                    .keep,
              )
              .toList();
          if (activePhones.length < 2) {
            continue;
          }
          final AnalyzedPhoneNumber keeper = _pickPreferredPhone(
            activePhones,
            planByContact,
          );
          for (final AnalyzedPhoneNumber phone in activePhones) {
            if (phone.contactId == keeper.contactId &&
                phone.entryIndex == keeper.entryIndex) {
              continue;
            }
            _markAsRemoved(planByContact, phone.contactId, phone.entryIndex);
          }
        }
      case CrossContactDuplicateAction.mergeContacts:
        mergePlans = _buildMergePlans(analysis, planByContact);
        for (final MergePlan mergePlan in mergePlans) {
          final Set<String> seenKeys = <String>{};
          int keptPhoneCount = 0;
          for (final String contactId in mergePlan.contactIds) {
            final ContactCleanupPlanEntry contactPlan =
                planByContact[contactId]!;
            for (final PlannedPhoneChange change in contactPlan.phoneChanges) {
              if (!change.keep) {
                continue;
              }
              keptPhoneCount += 1;
              if (change.deduplicationKey.isEmpty) {
                continue;
              }
              seenKeys.add(change.deduplicationKey);
            }
          }
          mergedDuplicateNumbers += keptPhoneCount - seenKeys.length;
        }
    }

    return CleanupPlan(
      contactPlans: planByContact.values.toList()
        ..sort(
          (ContactCleanupPlanEntry left, ContactCleanupPlanEntry right) =>
              left.contactName.compareTo(right.contactName),
        ),
      mergePlans: mergePlans,
      mergedDuplicateNumbers: mergedDuplicateNumbers,
    );
  }

  static List<MergePlan> _buildMergePlans(
    ContactAnalysisResult analysis,
    Map<String, ContactCleanupPlanEntry> planByContact,
  ) {
    final Map<String, String> parents = <String, String>{};
    for (final ContactSnapshot contact in analysis.contacts) {
      parents[contact.id] = contact.id;
    }

    for (final DuplicateGroup group in analysis.duplicateGroups) {
      if (!group.crossesContacts) {
        continue;
      }
      final List<String> contactIds = group.occurrences
          .map((DuplicateOccurrence occurrence) => occurrence.contactId)
          .toSet()
          .toList();
      if (contactIds.length < 2) {
        continue;
      }
      final String root = _find(parents, contactIds.first);
      for (final String contactId in contactIds.skip(1)) {
        _union(parents, root, contactId);
      }
    }

    final Map<String, List<ContactSnapshot>> components =
        <String, List<ContactSnapshot>>{};
    for (final ContactSnapshot contact in analysis.contacts) {
      final String root = _find(parents, contact.id);
      final List<ContactSnapshot> bucket = components.putIfAbsent(
        root,
        () => <ContactSnapshot>[],
      );
      bucket.add(contact);
    }

    final List<MergePlan> mergePlans = <MergePlan>[];
    for (final List<ContactSnapshot> contacts in components.values) {
      if (contacts.length < 2) {
        continue;
      }
      contacts.sort(
        (ContactSnapshot left, ContactSnapshot right) => _mergeScore(
          right,
          planByContact,
        ).compareTo(_mergeScore(left, planByContact)),
      );
      final ContactSnapshot primaryContact = contacts.first;
      mergePlans.add(
        MergePlan(
          primaryContactId: primaryContact.id,
          primaryContactName: primaryContact.displayName,
          contactIds: contacts
              .map((ContactSnapshot contact) => contact.id)
              .toList(),
          contactNames: contacts
              .map((ContactSnapshot contact) => contact.displayName)
              .toList(),
        ),
      );
    }

    mergePlans.sort(
      (MergePlan left, MergePlan right) =>
          left.primaryContactName.compareTo(right.primaryContactName),
    );
    return mergePlans;
  }

  static int _mergeScore(
    ContactSnapshot contact,
    Map<String, ContactCleanupPlanEntry> planByContact,
  ) {
    final ContactCleanupPlanEntry contactPlan = planByContact[contact.id]!;
    final int keptNumbers = contactPlan.phoneChanges
        .where((PlannedPhoneChange change) => change.keep)
        .length;
    return keptNumbers * 1000 + contact.displayName.trim().length;
  }

  static void _markAsRemoved(
    Map<String, ContactCleanupPlanEntry> planByContact,
    String contactId,
    int entryIndex,
  ) {
    final ContactCleanupPlanEntry contactPlan = planByContact[contactId]!;
    final PlannedPhoneChange currentChange =
        contactPlan.phoneChanges[entryIndex];
    contactPlan.phoneChanges[entryIndex] = PlannedPhoneChange(
      entryIndex: currentChange.entryIndex,
      originalNumber: currentChange.originalNumber,
      deduplicationKey: currentChange.deduplicationKey,
      keep: false,
      replacementNumber: currentChange.replacementNumber,
    );
  }

  static AnalyzedPhoneNumber _pickPreferredPhone(
    List<AnalyzedPhoneNumber> phones,
    Map<String, ContactCleanupPlanEntry> planByContact,
  ) {
    final List<AnalyzedPhoneNumber> sorted = phones.toList()
      ..sort((AnalyzedPhoneNumber left, AnalyzedPhoneNumber right) {
        final int scoreComparison = _preferredPhoneScore(
          right,
          planByContact,
        ).compareTo(_preferredPhoneScore(left, planByContact));
        if (scoreComparison != 0) {
          return scoreComparison;
        }
        return left.entryIndex.compareTo(right.entryIndex);
      });
    return sorted.first;
  }

  static int _preferredPhoneScore(
    AnalyzedPhoneNumber phone,
    Map<String, ContactCleanupPlanEntry> planByContact,
  ) {
    final ContactCleanupPlanEntry contactPlan = planByContact[phone.contactId]!;
    final int keptNumbers = contactPlan.phoneChanges
        .where((PlannedPhoneChange change) => change.keep)
        .length;
    int score = keptNumbers * 100;
    if (phone.normalizedNumber != null) {
      score += 10;
    }
    if (!phone.hasFormattingNoise) {
      score += 5;
    }
    if (!phone.isInvalidLength) {
      score += 3;
    }
    score += phone.contactName.trim().length;
    return score;
  }

  static String _phoneKey(String contactId, int entryIndex) {
    return '$contactId::$entryIndex';
  }

  static String _find(Map<String, String> parents, String contactId) {
    final String parent = parents[contactId]!;
    if (parent == contactId) {
      return contactId;
    }
    final String root = _find(parents, parent);
    parents[contactId] = root;
    return root;
  }

  static void _union(
    Map<String, String> parents,
    String leftId,
    String rightId,
  ) {
    final String leftRoot = _find(parents, leftId);
    final String rightRoot = _find(parents, rightId);
    if (leftRoot == rightRoot) {
      return;
    }
    parents[rightRoot] = leftRoot;
  }
}
