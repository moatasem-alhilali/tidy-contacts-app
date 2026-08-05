// ignore_for_file: package_api_docs

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_manager/design-system-package/src/utils/request_state.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';

class ContactCleanerState {
  const ContactCleanerState({
    required this.rules,
    required this.options,
    this.isInitialized = false,
    this.isSupported = true,
    this.scanState = RequestState.initial,
    this.backupState = RequestState.initial,
    this.applyState = RequestState.initial,
    this.permissionStatus = PermissionStatus.notDetermined,
    this.analysis,
    this.plan,
    this.errorMessage,
    this.lastBackupPath,
  });

  final bool isInitialized;
  final bool isSupported;
  final RequestState scanState;
  final RequestState backupState;
  final RequestState applyState;
  final PermissionStatus permissionStatus;
  final ContactAnalysisResult? analysis;
  final CleanupPlan? plan;
  final String? errorMessage;
  final String? lastBackupPath;
  final List<NormalizationRule> rules;
  final CleanupOptions options;

  bool get hasPermission {
    return permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.limited;
  }

  bool get isPermissionDenied {
    return permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied ||
        permissionStatus == PermissionStatus.restricted;
  }

  bool get isScanning {
    return scanState == RequestState.loading;
  }

  bool get isBackingUp {
    return backupState == RequestState.loading;
  }

  bool get isApplying {
    return applyState == RequestState.loading;
  }

  bool get hasAnalysis {
    return analysis != null;
  }

  bool get hasChangesReady {
    return plan?.hasChanges ?? false;
  }

  ContactCleanerState copyWith({
    bool? isInitialized,
    bool? isSupported,
    RequestState? scanState,
    RequestState? backupState,
    RequestState? applyState,
    PermissionStatus? permissionStatus,
    ContactAnalysisResult? analysis,
    CleanupPlan? plan,
    List<NormalizationRule>? rules,
    CleanupOptions? options,
    Object? errorMessage = _copySentinel,
    Object? lastBackupPath = _copySentinel,
  }) {
    return ContactCleanerState(
      isInitialized: isInitialized ?? this.isInitialized,
      isSupported: isSupported ?? this.isSupported,
      scanState: scanState ?? this.scanState,
      backupState: backupState ?? this.backupState,
      applyState: applyState ?? this.applyState,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      analysis: analysis ?? this.analysis,
      plan: plan ?? this.plan,
      rules: rules ?? this.rules,
      options: options ?? this.options,
      errorMessage: errorMessage == _copySentinel
          ? this.errorMessage
          : errorMessage as String?,
      lastBackupPath: lastBackupPath == _copySentinel
          ? this.lastBackupPath
          : lastBackupPath as String?,
    );
  }

  static const Object _copySentinel = Object();
}
