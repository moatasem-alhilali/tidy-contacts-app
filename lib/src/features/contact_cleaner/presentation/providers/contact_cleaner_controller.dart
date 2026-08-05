// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types
// ignore_for_file: package_api_docs, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/src/utils/request_state.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/di/injection_container.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/repositories/contact_cleaner_engine.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/repositories/contact_cleaner_repository.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/providers/contact_cleaner_state.dart';

final contactCleanerControllerProvider =
    NotifierProvider<ContactCleanerController, ContactCleanerState>(
      ContactCleanerController.new,
    );

class ContactCleanerController extends Notifier<ContactCleanerState> {
  final Map<String, Contact> _scannedContactsById = <String, Contact>{};
  List<ContactSnapshot> _cachedSnapshots = const <ContactSnapshot>[];

  ContactRepository get _repository =>
      ref.read(contactCleanerRepositoryProvider);

  @override
  ContactCleanerState build() {
    return ContactCleanerState(
      rules: _defaultRules,
      options: const CleanupOptions(),
    );
  }

  Future<void> initialize() async {
    if (state.isInitialized) {
      return;
    }
    if (!_isSupportedPlatform()) {
      state = state.copyWith(
        isInitialized: true,
        isSupported: false,
        errorMessage: LocaleKeys.contact_cleaner_platform_not_supported_subtitle
            .tr(),
      );
      return;
    }
    await requestPermissionAndScan();
  }

  Future<void> requestPermissionAndScan() async {
    state = state.copyWith(
      isInitialized: true,
      scanState: RequestState.loading,
      errorMessage: null,
    );
    try {
      final PermissionStatus permissionStatus = await _repository
          .requestPermission();
      state = state.copyWith(permissionStatus: permissionStatus);
      if (!state.hasPermission) {
        state = state.copyWith(scanState: RequestState.initial);
        return;
      }
      await scanContacts(showLoader: false);
    } catch (error) {
      state = state.copyWith(
        scanState: RequestState.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> scanContacts({bool showLoader = true}) async {
    if (!state.hasPermission) {
      return;
    }
    if (showLoader) {
      state = state.copyWith(
        scanState: RequestState.loading,
        errorMessage: null,
      );
    }
    try {
      final List<Contact> contacts = await _repository.fetchScanContacts();
      _scannedContactsById
        ..clear()
        ..addEntries(
          contacts
              .where((Contact contact) => contact.id != null)
              .map(
                (Contact contact) =>
                    MapEntry<String, Contact>(contact.id!, contact),
              ),
        );
      _cachedSnapshots = contacts
          .where((Contact contact) => contact.id != null)
          .map(_toSnapshot)
          .toList();
      final ContactAnalysisRequest request = ContactAnalysisRequest(
        contacts: _cachedSnapshots,
        rules: state.rules,
      );
      final Map<String, Object?> rawResult = await compute(
        analyzeContactsPayload,
        request.toMap(),
      );
      final ContactAnalysisResult analysis = ContactAnalysisResult.fromMap(
        rawResult,
      );
      final CleanupPlan plan = ContactCleanupPlanner.build(
        analysis,
        state.options,
      );
      state = state.copyWith(
        scanState: RequestState.success,
        analysis: analysis,
        plan: plan,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        scanState: RequestState.error,
        errorMessage: error.toString(),
      );
    }
  }

  void applyAutoCleanPreset() {
    state = state.copyWith(
      options: state.options.copyWith(
        normalizeNumbers: true,
        removeDuplicatesWithinContact: true,
        crossContactAction: CrossContactDuplicateAction.mergeContacts,
      ),
    );
    _rebuildPlan();
  }

  void setNormalizeNumbers(bool value) {
    state = state.copyWith(
      options: state.options.copyWith(normalizeNumbers: value),
    );
    _rebuildPlan();
  }

  void setRemoveDuplicatesWithinContact(bool value) {
    state = state.copyWith(
      options: state.options.copyWith(removeDuplicatesWithinContact: value),
    );
    _rebuildPlan();
  }

  void setCrossContactAction(CrossContactDuplicateAction action) {
    state = state.copyWith(
      options: state.options.copyWith(crossContactAction: action),
    );
    _rebuildPlan();
  }

  Future<void> addRule(NormalizationRule rule) async {
    state = state.copyWith(rules: <NormalizationRule>[...state.rules, rule]);
    await _reanalyze();
  }

  Future<void> updateRule(NormalizationRule rule) async {
    final List<NormalizationRule> rules = state.rules
        .map(
          (NormalizationRule current) => current.id == rule.id ? rule : current,
        )
        .toList();
    state = state.copyWith(rules: rules);
    await _reanalyze();
  }

  Future<void> removeRule(String ruleId) async {
    state = state.copyWith(
      rules: state.rules
          .where((NormalizationRule rule) => rule.id != ruleId)
          .toList(),
    );
    await _reanalyze();
  }

  Future<void> createBackup() async {
    state = state.copyWith(
      backupState: RequestState.loading,
      errorMessage: null,
    );
    try {
      final String path = await _repository.exportBackupFile();
      state = state.copyWith(
        backupState: RequestState.success,
        lastBackupPath: path,
      );
    } catch (error) {
      state = state.copyWith(
        backupState: RequestState.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> applyFixes() async {
    final CleanupPlan? plan = state.plan;
    if (plan == null || !plan.hasChanges) {
      return;
    }
    state = state.copyWith(
      applyState: RequestState.loading,
      errorMessage: null,
    );
    try {
      await _repository.applyPlan(plan, _scannedContactsById);
      state = state.copyWith(applyState: RequestState.success);
      await scanContacts();
    } catch (error) {
      state = state.copyWith(
        applyState: RequestState.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> openSettings() {
    return _repository.openSettings();
  }

  void resetTransientStates({
    bool scan = false,
    bool backup = false,
    bool apply = false,
  }) {
    state = state.copyWith(
      scanState: scan ? RequestState.initial : null,
      backupState: backup ? RequestState.initial : null,
      applyState: apply ? RequestState.initial : null,
      errorMessage: null,
    );
  }

  Future<void> _reanalyze() async {
    if (_cachedSnapshots.isEmpty) {
      _rebuildPlan();
      return;
    }
    state = state.copyWith(scanState: RequestState.loading, errorMessage: null);
    try {
      final ContactAnalysisRequest request = ContactAnalysisRequest(
        contacts: _cachedSnapshots,
        rules: state.rules,
      );
      final Map<String, Object?> rawResult = await compute(
        analyzeContactsPayload,
        request.toMap(),
      );
      final ContactAnalysisResult analysis = ContactAnalysisResult.fromMap(
        rawResult,
      );
      final CleanupPlan plan = ContactCleanupPlanner.build(
        analysis,
        state.options,
      );
      state = state.copyWith(
        scanState: RequestState.success,
        analysis: analysis,
        plan: plan,
      );
    } catch (error) {
      state = state.copyWith(
        scanState: RequestState.error,
        errorMessage: error.toString(),
      );
    }
  }

  void _rebuildPlan() {
    final ContactAnalysisResult? analysis = state.analysis;
    if (analysis == null) {
      return;
    }
    state = state.copyWith(
      plan: ContactCleanupPlanner.build(analysis, state.options),
    );
  }

  bool _isSupportedPlatform() {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  ContactSnapshot _toSnapshot(Contact contact) {
    return ContactSnapshot(
      id: contact.id!,
      displayName: (contact.displayName ?? '').trim().isEmpty
          ? LocaleKeys.unnamed_contact.tr()
          : contact.displayName!.trim(),
      phones: contact.phones
          .asMap()
          .entries
          .map(
            (MapEntry<int, Phone> entry) => PhoneEntrySnapshot(
              index: entry.key,
              originalNumber: entry.value.number,
            ),
          )
          .toList(),
    );
  }

  static List<NormalizationRule> get _defaultRules => <NormalizationRule>[
    NormalizationRule(
      id: 'sa_mobile_10',
      label: LocaleKeys.contact_cleaner_default_rule_sa_mobile.tr(),
      expectedLength: 10,
      prefixes: <String>['05'],
      countryCode: '+966',
      removeTrunkPrefix: true,
      trunkPrefix: '0',
    ),
    NormalizationRule(
      id: 'ye_mobile_9',
      label: LocaleKeys.contact_cleaner_default_rule_ye_mobile.tr(),
      expectedLength: 9,
      prefixes: <String>['77', '78', '73', '71', '70'],
      countryCode: '+967',
    ),
  ];
}
