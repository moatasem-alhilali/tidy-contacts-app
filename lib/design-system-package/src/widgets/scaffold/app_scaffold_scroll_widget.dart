import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/services.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/design-system-package/src/widgets/scaffold/elastic_text_refresh_header.dart';
import 'package:hive_manager/design-system-package/src/widgets/scaffold/gesture_detector_widget.dart';
import 'package:hive_manager/src/core/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum SliverChildPosition { start, end, custom }

class AppScaffoldCustomScroll extends StatefulWidget {
  const AppScaffoldCustomScroll({
    this.child,
    this.slivers,
    this.sliverChildPosition = SliverChildPosition.start,
    this.customChildIndex,
    this.footer,
    this.bottomNavigationBar,
    this.scaffoldKey,
    this.statusBarColor,
    this.scaffoldBackgroundColor,
    this.statusBarIconLight,
    this.resizeToAvoidBottomInset,
    this.useTopSafeArea,
    this.useBottomSafeArea,
    this.padding,
    this.backgroundWidget,
    this.drawer,
    this.appBar,
    this.appBarTitle,
    this.onBack,
    this.isCenterTitle,
    this.refreshHeader,
    this.onRefresh,
    this.isElasticTextRefreshHeader = true,
    this.hasAppBar = true,
    super.key,
  });

  final Widget? child;
  final List<Widget>? slivers;
  final SliverChildPosition sliverChildPosition;
  final int? customChildIndex;
  final Widget? footer;
  final Widget? bottomNavigationBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color? scaffoldBackgroundColor;
  final bool? statusBarIconLight;
  final bool? resizeToAvoidBottomInset;
  final bool? useTopSafeArea;
  final bool? useBottomSafeArea;
  final Widget? backgroundWidget;
  final Widget? drawer;
  final Color? statusBarColor;
  final Widget? appBar;
  final bool? hasAppBar;
  final String? appBarTitle;
  final VoidCallback? onBack;
  final bool? isCenterTitle;

  final EdgeInsetsGeometry? padding;

  final Widget? refreshHeader;
  final bool isElasticTextRefreshHeader;
  final void Function()? onRefresh;

  @override
  State<AppScaffoldCustomScroll> createState() =>
      _AppScaffoldCustomScrollState();
}

class _AppScaffoldCustomScrollState extends State<AppScaffoldCustomScroll> {
  final ScrollController _scrollController = ScrollController();
  final _refreshController = RefreshController();

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isScrolled => _scrollOffset > 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      bottomNavigationBar: widget.footer != null
          ? IntrinsicHeight(
              child: ColoredBox(
                color: context.colors.surface,
                child: SafeArea(top: false, child: widget.footer!),
              ),
            )
          : null,
      body: RefreshWidget(
        controller: _refreshController,
        header: widget.isElasticTextRefreshHeader
            ? const ElasticTextRefreshHeader()
            : widget.refreshHeader,
        onRefresh: widget.onRefresh == null
            ? widget.isElasticTextRefreshHeader
                  ? _refreshController.refreshCompleted
                  : null
            : () {
                widget.onRefresh!.call();
                _refreshController.refreshCompleted();
              },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (widget.hasAppBar ?? true) ...[
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: widget.statusBarColor ?? Colors.transparent,
                  statusBarIconBrightness: widget.statusBarIconLight ?? false
                      ? Brightness.light
                      : Brightness.dark,
                  statusBarBrightness: widget.statusBarIconLight ?? false
                      ? Brightness.light
                      : Brightness.dark,
                  systemNavigationBarColor: context.colors.surface,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness:
                      widget.statusBarIconLight ?? false
                      ? Brightness.dark
                      : Brightness.light,
                ),
                pinned: true,
                backgroundColor: _isScrolled
                    ? context.colors.background$10
                    : context.colors.surface,
                elevation: 2,
                leading: const SizedBox.shrink(),
                collapsedHeight: 52.h,
                expandedHeight: 52.h,
                toolbarHeight: 52.h,
                leadingWidth: 1,
                automaticallyImplyLeading: false,
                flexibleSpace: _isScrolled
                    ? BlurWidget(
                        sigmaX: 24,
                        sigmaY: 24,
                        child: Container(color: Colors.transparent),
                      )
                    : null,
                titleSpacing: 0,
                centerTitle: widget.isCenterTitle ?? true,
                title: AppBarWidget(
                  title: widget.appBarTitle ?? '',
                  onBack: widget.onBack,
                  isCenterTitle: widget.isCenterTitle ?? true,
                  elevation: !_isScrolled ? 3 : 0,
                ),
              ),
            ],
            ..._buildSlivers(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(BuildContext context) {
    final childSliver = SliverPadding(
      padding: EdgeInsets.only(top: 16.h),
      sliver: SliverToBoxAdapter(
        child: Stack(
          children: [
            if (widget.backgroundWidget != null) widget.backgroundWidget!,
            GestureDetectorWidget(
              hapticEnabled: false,
              onTap: () => Utils.disposeKeyboard(context),
              child: SafeArea(
                top: false,
                bottom: widget.useBottomSafeArea ?? true,
                child: Padding(
                  padding:
                      widget.padding ??
                      EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                        left: 16.w,
                        right: 16.w,
                      ),
                  child: widget.child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final slivers = List<Widget>.of(widget.slivers ?? []);
    if (widget.slivers != null) {
      // Insert child based on position
      switch (widget.sliverChildPosition) {
        case SliverChildPosition.start:
          slivers.insert(0, childSliver);
        case SliverChildPosition.end:
          slivers.add(childSliver);
        case SliverChildPosition.custom:
          final idx = (widget.customChildIndex ?? 0).clamp(0, slivers.length);
          slivers.insert(idx, childSliver);
      }

      return slivers;
    } else {
      // Only child
      return [childSliver];
    }
  }
}
