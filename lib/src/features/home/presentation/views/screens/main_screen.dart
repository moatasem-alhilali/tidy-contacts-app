// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: use_build_context_synchronously

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/src/utils/request_state.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/adaptive_showcase/adaptive_showcase_screen.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/providers/contact_cleaner_controller.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/providers/contact_cleaner_state.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(contactCleanerControllerProvider.notifier).initialize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ContactCleanerState state = ref.watch(
      contactCleanerControllerProvider,
    );
    final ContactCleanerController controller = ref.read(
      contactCleanerControllerProvider.notifier,
    );

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: LocaleKeys.contact_cleaner_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_subtitle.tr(),
        actions: [
          AdaptiveAppBarAction(
            icon: Icons.auto_awesome_outlined,
            iosSymbol: 'sparkles',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AdaptiveShowcaseScreen(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            kScreenPad,
            kGapSm,
            kScreenPad,
            0,
          ),
          child: _buildContent(context, state, controller),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ContactCleanerState state,
    ContactCleanerController controller,
  ) {
    if (!state.isSupported) {
      return ContactCleanerFailureState(
        icon: Icons.phonelink_erase_outlined,
        title: LocaleKeys.contact_cleaner_platform_not_supported_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_platform_not_supported_subtitle
            .tr(),
        buttonText: LocaleKeys.retry.tr(),
        onPressed: controller.initialize,
      );
    }

    if (state.isPermissionDenied && !state.hasAnalysis) {
      final bool shouldOpenSettings =
          state.permissionStatus.name.contains('permanently') ||
          state.permissionStatus == PermissionStatus.restricted;
      return ContactCleanerFailureState(
        icon: Icons.lock_outline,
        title: LocaleKeys.contact_cleaner_permission_required_title.tr(),
        subtitle: LocaleKeys.contact_cleaner_permission_required_subtitle.tr(),
        buttonText: shouldOpenSettings
            ? LocaleKeys.open_settings.tr()
            : LocaleKeys.request_permission.tr(),
        onPressed: shouldOpenSettings
            ? controller.openSettings
            : controller.requestPermissionAndScan,
      );
    }

    if (state.isScanning && !state.hasAnalysis) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (state.scanState == RequestState.error && !state.hasAnalysis) {
      return ContactCleanerFailureState(
        title: LocaleKeys.contact_cleaner_read_failed_title.tr(),
        subtitle: state.errorMessage,
        buttonText: LocaleKeys.retry.tr(),
        onPressed: controller.scanContacts,
      );
    }

    return Column(
      children: [
        ContactCleanerHeaderWidget(
          state: state,
          onScanPressed: () async {
            await controller.scanContacts();
            _showStateFeedback(
              context,
              controller,
              ref.read(contactCleanerControllerProvider),
            );
          },
          onBackupPressed: () => _handleBackup(context, controller),
          onApplyPressed: () => _showApplyConfirmation(context, controller),
        ),
        _TabSelector(
          selectedIndex: _tab,
          onChanged: (int index) => setState(() => _tab = index),
        ),
        const SizedBox(height: kGapMd),
        Expanded(
          child: IndexedStack(
            index: _tab,
            children: [
              ContactCleanerOverviewTab(analysis: state.analysis),
              ContactCleanerRulesTab(
                rules: state.rules,
                options: state.options,
                onNormalizeChanged: controller.setNormalizeNumbers,
                onWithinContactChanged:
                    controller.setRemoveDuplicatesWithinContact,
                onCrossContactChanged: controller.setCrossContactAction,
                onAutoCleanPressed: () {
                  controller.applyAutoCleanPreset();
                  _snack(
                    context,
                    LocaleKeys.contact_cleaner_auto_clean_preset_updated.tr(),
                    AdaptiveSnackBarType.success,
                  );
                },
                onAddRulePressed: () => _showRuleSheet(context, controller),
                onEditRulePressed: (NormalizationRule rule) =>
                    _showRuleSheet(context, controller, initialRule: rule),
                onDeleteRulePressed: (String ruleId) =>
                    _showDeleteRuleConfirmation(context, controller, ruleId),
              ),
              ContactCleanerDuplicatesTab(analysis: state.analysis),
              ContactCleanerPreviewTab(plan: state.plan),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleBackup(
    BuildContext context,
    ContactCleanerController controller,
  ) async {
    await controller.createBackup();
    final ContactCleanerState latestState = ref.read(
      contactCleanerControllerProvider,
    );
    if (latestState.backupState == RequestState.success &&
        latestState.lastBackupPath != null) {
      _snack(
        context,
        LocaleKeys.contact_cleaner_backup_created.tr(),
        AdaptiveSnackBarType.success,
      );
      controller.resetTransientStates(backup: true);
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[
            XFile(latestState.lastBackupPath!, mimeType: 'text/vcard'),
          ],
          title: LocaleKeys.contact_cleaner_backup_share_title.tr(),
        ),
      );
    } else {
      _showStateFeedback(context, controller, latestState);
    }
  }

  void _showRuleSheet(
    BuildContext context,
    ContactCleanerController controller, {
    NormalizationRule? initialRule,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ContactCleanerRuleFormSheet(
            initialRule: initialRule,
            onSubmitted: (NormalizationRule rule) async {
              if (initialRule == null) {
                await controller.addRule(rule);
              } else {
                await controller.updateRule(rule);
              }
              if (mounted) {
                _showStateFeedback(
                  context,
                  controller,
                  ref.read(contactCleanerControllerProvider),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteRuleConfirmation(
    BuildContext context,
    ContactCleanerController controller,
    String ruleId,
  ) async {
    await AdaptiveAlertDialog.show(
      context: context,
      title: LocaleKeys.contact_cleaner_delete_rule_title.tr(),
      message: LocaleKeys.contact_cleaner_delete_rule_message.tr(),
      icon: 'trash.fill',
      actions: [
        AlertAction(
          title: LocaleKeys.cancel.tr(),
          style: AlertActionStyle.cancel,
          onPressed: () {},
        ),
        AlertAction(
          title: LocaleKeys.contact_cleaner_delete_rule_action.tr(),
          style: AlertActionStyle.destructive,
          onPressed: () async {
            await controller.removeRule(ruleId);
            if (mounted) {
              _snack(
                context,
                LocaleKeys.contact_cleaner_delete_rule_success.tr(),
                AdaptiveSnackBarType.success,
              );
              controller.resetTransientStates(scan: true);
            }
          },
        ),
      ],
    );
  }

  Future<void> _showApplyConfirmation(
    BuildContext context,
    ContactCleanerController controller,
  ) async {
    await AdaptiveAlertDialog.show(
      context: context,
      title: LocaleKeys.contact_cleaner_apply_confirmation_title.tr(),
      message: LocaleKeys.contact_cleaner_apply_confirmation_message.tr(),
      icon: 'checkmark.seal.fill',
      actions: [
        AlertAction(
          title: LocaleKeys.cancel.tr(),
          style: AlertActionStyle.cancel,
          onPressed: () {},
        ),
        AlertAction(
          title: LocaleKeys.contact_cleaner_apply_confirmation_action.tr(),
          style: AlertActionStyle.primary,
          onPressed: () async {
            await controller.applyFixes();
            if (mounted) {
              _showStateFeedback(
                context,
                controller,
                ref.read(contactCleanerControllerProvider),
              );
            }
          },
        ),
      ],
    );
  }

  void _showStateFeedback(
    BuildContext context,
    ContactCleanerController controller,
    ContactCleanerState state,
  ) {
    if (state.errorMessage != null &&
        (state.scanState == RequestState.error ||
            state.applyState == RequestState.error ||
            state.backupState == RequestState.error)) {
      _snack(context, state.errorMessage!, AdaptiveSnackBarType.error);
      controller.resetTransientStates(
        scan: state.scanState == RequestState.error,
        backup: state.backupState == RequestState.error,
        apply: state.applyState == RequestState.error,
      );
      return;
    }

    if (state.applyState == RequestState.success) {
      _snack(
        context,
        LocaleKeys.contact_cleaner_apply_completed.tr(),
        AdaptiveSnackBarType.success,
      );
      controller.resetTransientStates(scan: true, apply: true);
      return;
    }

    if (state.scanState == RequestState.success) {
      _snack(
        context,
        LocaleKeys.contact_cleaner_scan_completed.tr(),
        AdaptiveSnackBarType.success,
      );
      controller.resetTransientStates(scan: true);
    }
  }

  void _snack(
    BuildContext context,
    String message,
    AdaptiveSnackBarType type,
  ) {
    AdaptiveSnackBar.show(context, message: message, type: type);
  }
}

/// Section switcher for the four Contact Cleaner tabs.
class _TabSelector extends StatelessWidget {
  const _TabSelector({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AdaptiveSegmentedControl(
      selectedIndex: selectedIndex,
      onValueChanged: onChanged,
      labels: [
        LocaleKeys.contact_cleaner_tab_overview.tr(),
        LocaleKeys.contact_cleaner_tab_rules.tr(),
        LocaleKeys.contact_cleaner_tab_duplicates.tr(),
        LocaleKeys.contact_cleaner_tab_preview.tr(),
      ],
    );
  }
}
