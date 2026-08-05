import 'package:flutter/cupertino.dart';
import 'package:hive_manager/design-system-package/src/extensions/extensions.dart';

/// A reusable base component for confirm delete dialogs using CupertinoAlertDialog.
///
/// This component provides a consistent delete confirmation experience across the app
/// with native iOS styling and Arabic localization support.
///
/// Example usage:
/// ```dart
/// final confirmed = await ConfirmDeleteDialog.show(
///   context: context,
///   title: 'حذف العنصر',
///   message: 'هل أنت متأكد من حذف هذا العنصر؟',
///   itemName: 'اسم العنصر',
/// );
///
/// if (confirmed == true) {
///   // Perform delete operation
/// }
/// ```
class ConfirmDeleteDialog {
  /// Shows a confirm delete dialog with the specified parameters.
  ///
  /// [context] - The build context
  /// [title] - The dialog title
  /// [message] - The confirmation message
  /// [itemName] - Optional name of the item being deleted (will be appended to message)
  /// [cancelText] - Text for the cancel button (defaults to 'إلغاء')
  /// [confirmText] - Text for the confirm button (defaults to 'حذف')
  ///
  /// Returns `true` if user confirmed deletion, `false` if cancelled, or `null` if dismissed
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? itemName,
    String cancelText = 'إلغاء',
    String confirmText = 'حذف',
  }) {
    final content = itemName != null ? '$message\n$itemName' : message;

    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: context.textStyles.titleMedium.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        content: Text(
          content,
          style: context.textStyles.labelMedium.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              cancelText,
              style: context.textStyles.labelMedium.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              confirmText,
              style: context.textStyles.labelMedium.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
