part of 'tabs.dart';

class TabWidget extends StatefulWidget {
  const TabWidget({
    required this.tabs,
    required this.children,
    this.value,
    super.key,
  });

  final int? value;
  final List<String> tabs;
  final List<Widget> children;

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  int selectedTab = 0;

  @override
  void initState() {
    selectedTab = widget.value ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Column(
        children: [
          TabBar(
            padding: EdgeInsets.symmetric(
              horizontal: context.insets.mn,
            ).copyWith(top: context.insets.xl),
            dividerHeight: 1.h,
            indicatorColor: context.colors.onPrimary,
            dividerColor: context.colors.onSecondaryContainer,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (value) => setState(() => selectedTab = value),
            tabs: [
              for (var i = 0; i < widget.tabs.length; ++i)
                _buildTab(widget.tabs[i], i),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) =>
      Padding(
        padding: EdgeInsets.only(bottom: context.insets.md),
        child: TextWidget(
          title,
          style: context.textStyles.labelMedium?.copyWith(
            color: index == selectedTab
                ? context.colors.onPrimary
                : context.colors.onTertiaryContainer,
          ),
        ),
      );
}
