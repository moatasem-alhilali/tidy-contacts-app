part of 'pagination.dart';

class ListViewSeparatedScrollPagination<T> extends StatefulWidget {
  const ListViewSeparatedScrollPagination({
    required this.builder,
    this.onLoading,
    this.pagination,
    this.isError,
    this.isLoading,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    this.onRefresh,
    this.parentPhysics,
    this.separatorWidget,
    super.key,
  });

  final dynamic Function()? onRefresh;
  final dynamic Function()? onLoading;
  final ApiPaginatedBaseResponse<T>? pagination;
  final Widget Function(T item) builder;
  final bool? isError;
  final bool? isLoading;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final ScrollPhysics? parentPhysics;
  final Widget? separatorWidget;

  @override
  State<ListViewSeparatedScrollPagination<T>> createState() =>
      _ListViewSeparatedScrollPaginationState<T>();
}

class _ListViewSeparatedScrollPaginationState<T>
    extends State<ListViewSeparatedScrollPagination<T>> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void didUpdateWidget(ListViewSeparatedScrollPagination<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pagination != oldWidget.pagination) {
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onLoading() async {
    if (widget.pagination?.hasMore == false) {
      _refreshController.loadNoData();
      return;
    }

    await widget.onLoading?.call();
    _refreshController.loadComplete();
  }

  Future<void> _onRefresh() async {
    await widget.onRefresh?.call();
    _refreshController
      ..refreshCompleted()
      ..loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: widget.onRefresh == null ? null : _onRefresh,
      enablePullUp: true,
      header: const ElasticTextRefreshHeader(),

      child: () {
        if (true == widget.isError) {
          return widget.errorWidget ?? const SizedBox.shrink();
        } else if (true == widget.isLoading) {
          return widget.loadingWidget ?? const SizedBox.shrink();
        } else if (true != widget.pagination?.data.isNotEmpty) {
          return widget.emptyWidget ?? const SizedBox.shrink();
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: context.insets.mn),
          separatorBuilder: (context, index) =>
              widget.separatorWidget ?? SizedBox(height: context.insets.lg),
          itemBuilder: (context, index) =>
              widget.builder(widget.pagination!.data[index]),
          itemCount: widget.pagination?.data.length ?? 0,
        );
      }(),
    );
  }
}
