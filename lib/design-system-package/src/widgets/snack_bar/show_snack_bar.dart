part of 'snack_bar.dart';

enum SnackBarPosition { top, bottom }

void showSnackBarApp(
  BuildContext context, {
  required WidgetBuilder builder,
  SnackBarPosition position = SnackBarPosition.top,
  int seconds = 5,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: position == SnackBarPosition.top
          ? context.statusTopHeight + context.insets.xl
          : null,
      bottom: position == SnackBarPosition.bottom
          ? context.statusBottomHeight
          : null,
      left: context.spaces.md,
      right: context.spaces.md,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: (_) => overlayEntry.remove(),
          child: builder(context),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: seconds), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
