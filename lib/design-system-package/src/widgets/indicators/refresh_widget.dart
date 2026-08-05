part of 'indicators.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    required this.child,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    this.header,
    this.enablePullUp = false,
    super.key,
  });

  final Widget child;
  final pull_to_refresh.RefreshController controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final bool enablePullUp;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return pull_to_refresh.SmartRefresher(
      controller: controller,
      onRefresh: onRefresh,
      enablePullUp: enablePullUp,
      onLoading: onLoading,
      enablePullDown: onRefresh != null,
      header: header ??
          pull_to_refresh.MaterialClassicHeader(
            color: context.colors.black,
          ),
      child: child,
    );
  }
}
