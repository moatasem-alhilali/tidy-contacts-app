// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/core/widgets/new/base_app_bar_widget.dart';
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

    return DefaultTabController(
      length: 4,
      child: AppScaffold(
        appBar: BaseAppBarWidget(
          title: LocaleKeys.contact_cleaner_title.tr(),
          subtitle: LocaleKeys.contact_cleaner_subtitle.tr(),
          showBackButton: false,
          preferredSizeHeight: 78,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.insets.mn.w,
            context.insets.sm.h,
            context.insets.mn.w,
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
      return FailureWidget(
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
      return FailureWidget(
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
        child: CircularProgressIndicator(color: context.colors.primary),
      );
    }

    if (state.scanState == RequestState.error && !state.hasAnalysis) {
      return FailureWidget(
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
          onBackupPressed: () async {
            await controller.createBackup();
            final ContactCleanerState latestState = ref.read(
              contactCleanerControllerProvider,
            );
            if (latestState.backupState == RequestState.success &&
                latestState.lastBackupPath != null) {
              context.showSuccessSnackbar(
                LocaleKeys.contact_cleaner_backup_created.tr(),
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
          },
          onApplyPressed: () => _showApplyConfirmation(context, controller),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.colors.secondary,
            borderRadius: BorderRadius.all(context.corners.rb),
            border: Border.all(
              color: context.colors.outline.withValues(alpha: 0.08),
            ),
          ),
          padding: EdgeInsets.all(context.insets.sm.w),
          child: TabBar(
            dividerColor: context.colors.background.withValues(alpha: 0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: context.colors.brandColor,
              borderRadius: BorderRadius.all(context.corners.rb),
            ),
            labelColor: context.colors.white,
            unselectedLabelColor: context.colors.onSecondary,
            labelStyle: context.textStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: context.textStyles.labelMedium,
            tabs: [
              Tab(text: LocaleKeys.contact_cleaner_tab_overview.tr()),
              Tab(text: LocaleKeys.contact_cleaner_tab_rules.tr()),
              Tab(text: LocaleKeys.contact_cleaner_tab_duplicates.tr()),
              Tab(text: LocaleKeys.contact_cleaner_tab_preview.tr()),
            ],
          ),
        ),
        SizedBox(height: context.insets.md.h),
        Expanded(
          child: TabBarView(
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
                  context.showSuccessSnackbar(
                    LocaleKeys.contact_cleaner_auto_clean_preset_updated.tr(),
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

  void _showRuleSheet(
    BuildContext context,
    ContactCleanerController controller, {
    NormalizationRule? initialRule,
  }) {
    context.showBaseBottomSheet(
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
    );
  }

  void _showDeleteRuleConfirmation(
    BuildContext context,
    ContactCleanerController controller,
    String ruleId,
  ) {
    context.showQuickActionSheet(
      title: LocaleKeys.contact_cleaner_delete_rule_title.tr(),
      message: LocaleKeys.contact_cleaner_delete_rule_message.tr(),
      actions: [
        QuickActionItem(
          title: LocaleKeys.contact_cleaner_delete_rule_action.tr(),
          isDestructive: true,
          onTap: () async {
            await controller.removeRule(ruleId);
            if (mounted) {
              Navigator.of(context).pop();
              context.showSuccessSnackbar(
                LocaleKeys.contact_cleaner_delete_rule_success.tr(),
              );
              controller.resetTransientStates(scan: true);
            }
          },
        ),
      ],
    );
  }

  void _showApplyConfirmation(
    BuildContext context,
    ContactCleanerController controller,
  ) {
    context.showQuickActionSheet(
      title: LocaleKeys.contact_cleaner_apply_confirmation_title.tr(),
      message: LocaleKeys.contact_cleaner_apply_confirmation_message.tr(),
      actions: [
        QuickActionItem(
          title: LocaleKeys.contact_cleaner_apply_confirmation_action.tr(),
          onTap: () async {
            Navigator.of(context).pop();
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
      context.showErrorSnackbar(state.errorMessage!);
      controller.resetTransientStates(
        scan: state.scanState == RequestState.error,
        backup: state.backupState == RequestState.error,
        apply: state.applyState == RequestState.error,
      );
      return;
    }

    if (state.applyState == RequestState.success) {
      context.showSuccessSnackbar(
        LocaleKeys.contact_cleaner_apply_completed.tr(),
      );
      controller.resetTransientStates(scan: true, apply: true);
      return;
    }

    if (state.scanState == RequestState.success) {
      context.showSuccessSnackbar(
        LocaleKeys.contact_cleaner_scan_completed.tr(),
      );
      controller.resetTransientStates(scan: true);
    }
  }
}
