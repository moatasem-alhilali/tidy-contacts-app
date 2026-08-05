part of 'pagination.dart';

class ListViewSeparatedScrollPaginationWithStickyHeader<T>
    extends StatefulWidget {
  const ListViewSeparatedScrollPaginationWithStickyHeader({
    required this.onRefresh,
    required this.onLoading,
    required this.pagination,
    required this.builder,
    required this.isError,
    required this.isLoading,
    required this.emptyWidget,
    required this.errorWidget,
    required this.loadingWidget,
    this.header,
    this.stickyHeaderAlignment,
    this.padding,
    this.headerRefresh,
    super.key,
  });

  final dynamic Function() onRefresh;
  final dynamic Function() onLoading;
  final ApiPaginatedBaseResponse<Grouped<T>>? pagination;
  final Widget Function(T item) builder;
  final Widget? header;
  final Widget? headerRefresh;
  final bool isError;
  final bool isLoading;
  final Widget emptyWidget;
  final Widget errorWidget;
  final Widget loadingWidget;
  final AlignmentGeometry? stickyHeaderAlignment;
  final EdgeInsetsGeometry? padding;

  @override
  State<ListViewSeparatedScrollPaginationWithStickyHeader<T>> createState() =>
      _ListViewSeparatedScrollPaginationWithStickyHeaderState<T>();
}

class _ListViewSeparatedScrollPaginationWithStickyHeaderState<T>
    extends State<ListViewSeparatedScrollPaginationWithStickyHeader<T>> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void didUpdateWidget(
    ListViewSeparatedScrollPaginationWithStickyHeader<T> oldWidget,
  ) {
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
    await widget.onLoading.call();
    _refreshController.loadComplete();
  }

  Future<void> _onRefresh() async {
    await widget.onRefresh.call();
    _refreshController
      ..refreshCompleted()
      ..loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverToBoxAdapter(child: widget.header),
          ),
        ],
        body: RefreshWidget(
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          enablePullUp: true,
          header: widget.headerRefresh,
          child: () {
            if (widget.isLoading) {
              return widget.loadingWidget;
            } else if (widget.isError) {
              return widget.errorWidget;
            } else if (true != widget.pagination?.data.isNotEmpty) {
              return widget.emptyWidget;
            }

            return CustomScrollView(
              slivers: widget.pagination!.data.asMap().entries.map<Widget>(
                (entry) {
                  final index = entry.key;
                  final type = entry.value;
                  return SliverStickyHeaderWidget(
                    title: type.groupName,
                    alignment: widget.stickyHeaderAlignment,
                    topPadding: index == 0 ? 0 : null,
                    sliver: SliverPadding(
                      padding: widget.padding ??
                          EdgeInsets.symmetric(horizontal: context.insets.mn),
                      sliver: SliverList.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: context.insets.lg),
                        itemBuilder: (context, index) =>
                            widget.builder(type.groupList[index]),
                        itemCount: type.groupList.length,
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          }(),
        ),
      ),
    );
  }
}
