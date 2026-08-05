// Action header for the Contact Cleaner: scan / backup / apply.
// AdaptiveCard + AdaptiveButton, styled from the standard ThemeData.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/providers/contact_cleaner_state.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';

class ContactCleanerHeaderWidget extends StatelessWidget {
  const ContactCleanerHeaderWidget({
    required this.state,
    required this.onScanPressed,
    required this.onBackupPressed,
    required this.onApplyPressed,
    super.key,
  });

  final ContactCleanerState state;
  final VoidCallback onScanPressed;
  final VoidCallback onBackupPressed;
  final VoidCallback onApplyPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final String? backupFileName = state.lastBackupPath?.split('/').last;
    final bool canApply = state.hasChangesReady && !state.isApplying;

    return ContactCleanerPanel(
      margin: const EdgeInsets.only(bottom: kGapMd),
      padding: const EdgeInsets.all(kGapLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contact_cleaner_header_title.tr(),
            style: tt.titleLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: kGapXs),
          Text(
            LocaleKeys.contact_cleaner_header_subtitle.tr(),
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          if (backupFileName != null) ...[
            const SizedBox(height: kGapMd),
            ContactCleanerTag(
              label: LocaleKeys.contact_cleaner_last_backup.tr(
                namedArgs: {'name': backupFileName},
              ),
              icon: Icons.folder_open_outlined,
            ),
          ],
          const SizedBox(height: kGapLg),
          SizedBox(
            width: double.infinity,
            child: AdaptiveButton(
              onPressed: onScanPressed,
              enabled: !state.isScanning,
              size: AdaptiveButtonSize.large,
              style: state.hasAnalysis
                  ? AdaptiveButtonStyle.tinted
                  : AdaptiveButtonStyle.filled,
              label: state.isScanning
                  ? LocaleKeys.contact_cleaner_scanning.tr()
                  : state.hasAnalysis
                  ? LocaleKeys.contact_cleaner_rescan.tr()
                  : LocaleKeys.contact_cleaner_start_scan.tr(),
            ),
          ),
          const SizedBox(height: kGapSm),
          Row(
            children: [
              Expanded(
                child: AdaptiveButton(
                  onPressed: onBackupPressed,
                  enabled: !state.isBackingUp,
                  style: AdaptiveButtonStyle.tinted,
                  label: state.isBackingUp
                      ? LocaleKeys.contact_cleaner_exporting.tr()
                      : LocaleKeys.contact_cleaner_backup.tr(),
                ),
              ),
              const SizedBox(width: kGapSm),
              Expanded(
                child: AdaptiveButton(
                  onPressed: onApplyPressed,
                  enabled: canApply,
                  label: state.isApplying
                      ? LocaleKeys.contact_cleaner_applying.tr()
                      : LocaleKeys.contact_cleaner_apply_fixes.tr(),
                ),
              ),
            ],
          ),
          const SizedBox(height: kGapMd),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: kRadiusTile,
            ),
            child: Padding(
              padding: const EdgeInsets.all(kGapMd),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user_outlined, color: cs.primary),
                  const SizedBox(width: kGapSm),
                  Expanded(
                    child: Text(
                      state.hasChangesReady
                          ? LocaleKeys.contact_cleaner_changes_ready_note.tr()
                          : LocaleKeys.contact_cleaner_no_changes_note.tr(),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
