// Proves the normalization engine handles every common storage form of
// Saudi (+966) and Yemen (+967) numbers, and never corrupts a number it
// cannot confidently normalize.

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/repositories/contact_cleaner_engine.dart';

// Mirrors ContactCleanerController._defaultRules.
const List<NormalizationRule> _defaultRules = <NormalizationRule>[
  NormalizationRule(
    id: 'sa_mobile_10',
    label: 'SA 05',
    expectedLength: 10,
    prefixes: <String>['05'],
    countryCode: '+966',
    removeTrunkPrefix: true,
    trunkPrefix: '0',
  ),
  NormalizationRule(
    id: 'sa_mobile_9',
    label: 'SA 5',
    expectedLength: 9,
    prefixes: <String>['5'],
    countryCode: '+966',
  ),
  NormalizationRule(
    id: 'ye_mobile_9',
    label: 'YE 7',
    expectedLength: 9,
    prefixes: <String>['70', '71', '73', '77', '78'],
    countryCode: '+967',
  ),
  NormalizationRule(
    id: 'ye_mobile_10',
    label: 'YE 07',
    expectedLength: 10,
    prefixes: <String>['070', '071', '073', '077', '078'],
    countryCode: '+967',
    removeTrunkPrefix: true,
    trunkPrefix: '0',
  ),
];

AnalyzedPhoneNumber _analyzeOne(String number) {
  final ContactAnalysisResult result = ContactAnalysisEngine.analyze(
    ContactAnalysisRequest(
      contacts: <ContactSnapshot>[
        ContactSnapshot(
          id: '1',
          displayName: 'Test',
          phones: <PhoneEntrySnapshot>[
            PhoneEntrySnapshot(index: 0, originalNumber: number),
          ],
        ),
      ],
      rules: _defaultRules,
    ),
  );
  return result.analyzedPhones.first;
}

void main() {
  group('Saudi numbers → +966551234567', () {
    const List<String> forms = <String>[
      '0551234567', // local with trunk 0
      '966551234567', // country code without +
      '+966 55 123 4567', // international with spaces
      '00966551234567', // 00 international prefix
      '٠٥٥١٢٣٤٥٦٧', // Arabic-Indic digits
      '(055) 123-4567', // formatting noise
    ];
    for (final String form in forms) {
      test('"$form"', () {
        expect(_analyzeOne(form).normalizedNumber, '+966551234567');
      });
    }
  });

  group('Yemen numbers → +967771234567', () {
    const List<String> forms = <String>[
      '771234567', // local (9 digits, no 0)
      '0771234567', // local with trunk 0
      '967771234567', // country code without +
      '+967771234567', // international
      '00967771234567', // 00 international prefix
    ];
    for (final String form in forms) {
      test('"$form"', () {
        expect(_analyzeOne(form).normalizedNumber, '+967771234567');
      });
    }
  });

  test('all Saudi forms share one comparison key (dedupe correctly)', () {
    final Set<String?> keys = <String?>{
      _analyzeOne('0551234567').comparisonKey,
      _analyzeOne('551234567').comparisonKey,
      _analyzeOne('966551234567').comparisonKey,
      _analyzeOne('+966551234567').comparisonKey,
      _analyzeOne('00966551234567').comparisonKey,
    };
    expect(keys, hasLength(1));
    expect(keys.first, '+966551234567');
  });

  test('foreign international number is preserved, not misclassified', () {
    final AnalyzedPhoneNumber us = _analyzeOne('+14155552671');
    expect(us.normalizedNumber, '+14155552671');
    expect(us.isMissingCountryCode, isFalse);
  });

  test('ambiguous short local number is never given a fake country code', () {
    final AnalyzedPhoneNumber short = _analyzeOne('12345');
    expect(short.normalizedNumber, isNull); // no rule matched -> untouched
    expect(short.originalNumber, '12345');
    expect(short.isInvalidLength, isTrue);
  });

  test('unmatched local number keeps its digits and is flagged', () {
    // Not a Saudi/Yemen mobile pattern; must not be corrupted.
    final AnalyzedPhoneNumber other = _analyzeOne('0111234567');
    expect(other.normalizedNumber, isNull);
    expect(other.isUnmatchedLocal, isTrue);
    expect(other.originalNumber, '0111234567');
  });
}
