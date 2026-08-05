import 'package:flutter_test/flutter_test.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/repositories/contact_cleaner_engine.dart';

void main() {
  group('ContactAnalysisEngine', () {
    test('normalizes local Saudi numbers and Arabic digits', () {
      final ContactAnalysisResult result = ContactAnalysisEngine.analyze(
        ContactAnalysisRequest(
          contacts: const <ContactSnapshot>[
            ContactSnapshot(
              id: '1',
              displayName: 'Ahmed',
              phones: <PhoneEntrySnapshot>[
                PhoneEntrySnapshot(index: 0, originalNumber: '٠٥٥ 123 4567'),
              ],
            ),
          ],
          rules: const <NormalizationRule>[
            NormalizationRule(
              id: 'sa',
              label: 'Saudi mobile',
              expectedLength: 10,
              prefixes: <String>['05'],
              countryCode: '+966',
              removeTrunkPrefix: true,
              trunkPrefix: '0',
            ),
          ],
        ),
      );

      expect(result.analyzedPhones, hasLength(1));
      expect(result.analyzedPhones.first.normalizedNumber, '+966551234567');
      expect(result.analyzedPhones.first.isMissingCountryCode, isTrue);
      expect(result.stats.correctedNumbers, 1);
    });

    test('detects duplicate numbers across and within contacts', () {
      final ContactAnalysisResult result = ContactAnalysisEngine.analyze(
        ContactAnalysisRequest(
          contacts: const <ContactSnapshot>[
            ContactSnapshot(
              id: '1',
              displayName: 'Ali',
              phones: <PhoneEntrySnapshot>[
                PhoneEntrySnapshot(index: 0, originalNumber: '0551234567'),
                PhoneEntrySnapshot(index: 1, originalNumber: '+966551234567'),
              ],
            ),
            ContactSnapshot(
              id: '2',
              displayName: 'Sara',
              phones: <PhoneEntrySnapshot>[
                PhoneEntrySnapshot(index: 0, originalNumber: '00966551234567'),
              ],
            ),
          ],
          rules: const <NormalizationRule>[
            NormalizationRule(
              id: 'sa',
              label: 'Saudi mobile',
              expectedLength: 10,
              prefixes: <String>['05'],
              countryCode: '+966',
              removeTrunkPrefix: true,
              trunkPrefix: '0',
            ),
          ],
        ),
      );

      expect(result.duplicateGroups, hasLength(1));
      expect(result.crossContactDuplicates, hasLength(1));
      expect(result.withinContactDuplicates, hasLength(1));
      expect(result.duplicateGroups.first.occurrences, hasLength(3));
    });

    test('builds merge cleanup plans for cross-contact duplicates', () {
      final ContactAnalysisResult result = ContactAnalysisEngine.analyze(
        ContactAnalysisRequest(
          contacts: const <ContactSnapshot>[
            ContactSnapshot(
              id: '1',
              displayName: 'Ali Primary',
              phones: <PhoneEntrySnapshot>[
                PhoneEntrySnapshot(index: 0, originalNumber: '0551234567'),
                PhoneEntrySnapshot(index: 1, originalNumber: '0500000000'),
              ],
            ),
            ContactSnapshot(
              id: '2',
              displayName: 'Ali Copy',
              phones: <PhoneEntrySnapshot>[
                PhoneEntrySnapshot(index: 0, originalNumber: '+966551234567'),
              ],
            ),
          ],
          rules: const <NormalizationRule>[
            NormalizationRule(
              id: 'sa',
              label: 'Saudi mobile',
              expectedLength: 10,
              prefixes: <String>['05'],
              countryCode: '+966',
              removeTrunkPrefix: true,
              trunkPrefix: '0',
            ),
          ],
        ),
      );

      final CleanupPlan plan = ContactCleanupPlanner.build(
        result,
        const CleanupOptions(
          normalizeNumbers: true,
          removeDuplicatesWithinContact: true,
          crossContactAction: CrossContactDuplicateAction.mergeContacts,
        ),
      );

      expect(plan.mergePlans, hasLength(1));
      expect(plan.mergePlans.first.primaryContactId, '1');
      expect(plan.contactsToDelete, 1);
      expect(plan.numbersNormalized, greaterThanOrEqualTo(1));
    });
  });
}
