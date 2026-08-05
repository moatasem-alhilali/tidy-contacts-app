part of 'pagination.dart';

class ListViewSeparatedScrollPaginationWithHeaderScroll<T>
    extends StatefulWidget {
  const ListViewSeparatedScrollPaginationWithHeaderScroll({
    required this.onLoading,
    required this.pagination,
    required this.builder,
    required this.header,
    required this.isError,
    required this.isLoading,
    required this.emptyWidget,
    required this.errorWidget,
    required this.loadingWidget,
    this.onRefresh,
    this.parentPhysics,
    this.separatorWidget,
    super.key,
  });

  final dynamic Function()? onRefresh;
  final dynamic Function() onLoading;
  final ApiPaginatedBaseResponse<T>? pagination;
  final Widget Function(T item) builder;
  final Widget header;
  final bool isError;
  final bool isLoading;
  final Widget emptyWidget;
  final Widget errorWidget;
  final Widget loadingWidget;
  final ScrollPhysics? parentPhysics;
  final Widget? separatorWidget;

  @override
  State<ListViewSeparatedScrollPaginationWithHeaderScroll<T>> createState() =>
      _ListViewSeparatedScrollPaginationWithHeaderScrollState<T>();
}

class _ListViewSeparatedScrollPaginationWithHeaderScrollState<T>
    extends State<ListViewSeparatedScrollPaginationWithHeaderScroll<T>> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void didUpdateWidget(
    ListViewSeparatedScrollPaginationWithHeaderScroll<T> oldWidget,
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
    await widget.onRefresh?.call();
    _refreshController
      ..refreshCompleted()
      ..loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: widget.parentPhysics,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
          <Widget>[
        const SliverToBoxAdapter(),
      ],
      body: RefreshWidget(
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: widget.onRefresh == null ? null : _onRefresh,
        enablePullUp: true,
        child: () {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: widget.header),
              if (widget.isError)
                SliverToBoxAdapter(child: widget.errorWidget)
              else if (widget.isLoading)
                SliverToBoxAdapter(child: widget.loadingWidget)
              else if (true != widget.pagination?.data.isNotEmpty)
                SliverToBoxAdapter(child: widget.emptyWidget),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.insets.mn),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) =>
                      widget.separatorWidget ??
                      SizedBox(height: context.insets.lg),
                  itemBuilder: (BuildContext context, int index) =>
                      widget.builder(widget.pagination!.data[index]),
                  itemCount: widget.pagination?.data.length ?? 0,
                ),
              ),
            ],
          );
        }(),
      ),
    );
  }
}
