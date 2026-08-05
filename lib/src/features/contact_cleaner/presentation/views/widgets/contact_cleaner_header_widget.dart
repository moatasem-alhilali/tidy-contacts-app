// Header — redesigned as a full-bleed gradient HERO band (not a card).
// It owns the top safe-area inset, shows the title + a showcase shortcut,
// three round glass actions (scan / backup / apply) and a status strip.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/providers/contact_cleaner_state.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_design.dart';

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
    final double topInset = MediaQuery.paddingOf(context).top;
    final bool canApply = state.hasChangesReady && !state.isApplying;

    return HeroBand(
      padding: EdgeInsets.fromLTRB(
        kGapLg,
        topInset + kGapMd,
        kGapLg,
        kGapLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contact_cleaner_title.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            LocaleKeys.contact_cleaner_subtitle.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: kGapLg),
          Row(
            children: [
              Expanded(
                child: HeroAction(
                  icon: Icons.radar,
                  busy: state.isScanning,
                  label: state.hasAnalysis
                      ? LocaleKeys.contact_cleaner_rescan.tr()
                      : LocaleKeys.contact_cleaner_start_scan.tr(),
                  onTap: onScanPressed,
                ),
              ),
              Expanded(
                child: HeroAction(
                  icon: Icons.cloud_download_outlined,
                  busy: state.isBackingUp,
                  label: LocaleKeys.contact_cleaner_backup.tr(),
                  onTap: onBackupPressed,
                ),
              ),
              Expanded(
                child: HeroAction(
                  icon: Icons.auto_fix_high,
                  busy: state.isApplying,
                  enabled: canApply,
                  label: LocaleKeys.contact_cleaner_apply_fixes.tr(),
                  onTap: onApplyPressed,
                ),
              ),
            ],
          ),
          const SizedBox(height: kGapLg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: kGapMd,
              vertical: kGapSm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: kRadiusPill,
            ),
            child: Row(
              children: [
                Icon(
                  state.hasChangesReady
                      ? Icons.check_circle
                      : Icons.shield_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: kGapSm),
                Expanded(
                  child: Text(
                    state.hasChangesReady
                        ? LocaleKeys.contact_cleaner_changes_ready_note.tr()
                        : LocaleKeys.contact_cleaner_no_changes_note.tr(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
