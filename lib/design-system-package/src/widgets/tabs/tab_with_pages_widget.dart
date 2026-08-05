part of 'tabs.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    required this.titles,
    required this.pages,
    this.tabController,
    this.onTabChanged,
    this.initialIndex = 0,
    this.padding,
    super.key,
  }) : assert(titles.length == pages.length);

  final List<String> titles;
  final List<Widget> pages;
  final TabController? tabController;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;
  final EdgeInsetsGeometry? padding;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.tabController == null) {
      _tabController = TabController(
        length: widget.titles.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
    } else {
      _tabController = widget.tabController!;
    }
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && widget.onTabChanged != null) {
        widget.onTabChanged!(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    if (widget.tabController == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    if (oldWidget.initialIndex != widget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skeleton.keep(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: context.insets.mn),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(context.corners.rc360),
              color: context.colors.primary,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.all(context.corners.rc360),
                color: context.colors.tertiary,
              ),
              padding: EdgeInsets.all(context.insets.sm),
              tabs: widget.titles.map((title) => _Tap(title: title)).toList(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Material(
              color: Colors.transparent,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.pages,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tap extends StatelessWidget {
  const _Tap({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      child: TextWidget(
        title,
        textAlign: TextAlign.center,
        style: context.textStyles.labelLarge.copyWith(
          color: context.colors.onPrimary,
        ),
      ),
    );
  }
}
