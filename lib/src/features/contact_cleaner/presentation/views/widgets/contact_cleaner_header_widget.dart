// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
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
    final String? backupFileName = state.lastBackupPath?.split('/').last;
    final bool canApply = state.hasChangesReady && !state.isApplying;

    return ContactCleanerPanel(
      margin: EdgeInsets.only(bottom: context.insets.md.h),
      padding: EdgeInsets.all(context.insets.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            LocaleKeys.contact_cleaner_header_title.tr(),
            style: context.textStyles.titleLarge.copyWith(
              color: context.colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.insets.sm.h),
          TextWidget(
            LocaleKeys.contact_cleaner_header_subtitle.tr(),
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.onSecondary,
            ),
          ),
          if (backupFileName != null) ...[
            SizedBox(height: context.insets.lg.h),
            ContactCleanerTag(
              label: LocaleKeys.contact_cleaner_last_backup.tr(
                namedArgs: {'name': backupFileName},
              ),
              icon: Icons.folder_open_outlined,
              backgroundColor: context.colors.secondary,
              textColor: context.colors.onPrimaryContainer,
            ),
          ],
          SizedBox(height: context.insets.lg.h),
          ButtonProgressStateWidget(
            state: state.scanState,
            text: state.hasAnalysis
                ? LocaleKeys.contact_cleaner_rescan.tr()
                : LocaleKeys.contact_cleaner_start_scan.tr(),
            textLoading: LocaleKeys.contact_cleaner_scanning.tr(),
            marginVertical: 0,
            defaultColor: state.hasAnalysis
                ? context.colors.secondary
                : context.colors.primary,
            colorText: state.hasAnalysis
                ? context.colors.onPrimaryContainer
                : context.colors.onPrimary,
            onPressed: onScanPressed,
          ),
          SizedBox(height: context.insets.sm.h),
          Row(
            children: [
              Expanded(
                child: ButtonProgressStateWidget(
                  state: state.backupState,
                  text: LocaleKeys.contact_cleaner_backup.tr(),
                  textLoading: LocaleKeys.contact_cleaner_exporting.tr(),
                  marginVertical: 0,
                  defaultColor: context.colors.secondary,
                  colorText: context.colors.onPrimaryContainer,
                  onPressed: onBackupPressed,
                ),
              ),
              SizedBox(width: context.insets.sm.w),
              Expanded(
                child: IgnorePointer(
                  ignoring: !canApply,
                  child: Opacity(
                    opacity: canApply ? 1 : 0.58,
                    child: ButtonProgressStateWidget(
                      state: state.applyState,
                      text: LocaleKeys.contact_cleaner_apply_fixes.tr(),
                      textLoading: LocaleKeys.contact_cleaner_applying.tr(),
                      marginVertical: 0,
                      defaultColor: context.colors.brandColor,
                      colorText: context.colors.white,
                      onPressed: canApply ? onApplyPressed : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.insets.md.h),
          ContactCleanerPanel(
            padding: EdgeInsets.all(context.insets.md.w),
            color: context.colors.brand10Color,
            borderColor: context.colors.brand10Color,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: context.colors.primary,
                  size: context.spaces.lg,
                ),
                SizedBox(width: context.insets.sm.w),
                Expanded(
                  child: TextWidget(
                    state.hasChangesReady
                        ? LocaleKeys.contact_cleaner_changes_ready_note.tr()
                        : LocaleKeys.contact_cleaner_no_changes_note.tr(),
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
