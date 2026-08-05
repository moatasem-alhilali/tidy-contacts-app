part of 'animations.dart';

class NewsTickerBuilder extends StatefulWidget {
  const NewsTickerBuilder({
    required this.newsList,
    this.height,
    this.textStyle,
    this.scrollSpeed,
    this.backgroundColor,
    this.separator,
    super.key,
  });

  final List<Widget> newsList;
  final double? height;
  final TextStyle? textStyle;
  final Duration? scrollSpeed;
  final Color? backgroundColor;
  final Widget? separator;

  @override
  State<NewsTickerBuilder> createState() => _NewsTickerBuilderState();
}

class _NewsTickerBuilderState extends State<NewsTickerBuilder>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late List<Widget> _infiniteNewsList;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _infiniteNewsList = List.from(widget.newsList)
      ..addAll(widget.newsList); // Duplicate list for infinite scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() {
    if (_scrollController.hasClients) {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: widget.scrollSpeed ?? const Duration(seconds: 30),
        curve: Curves.linear,
      )
          .then((_) {
        // Reset to the beginning without visible jump
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
          _startScrolling();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 36,
      color: widget.backgroundColor ?? context.colors.onSecondaryContainer,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _infiniteNewsList.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              _infiniteNewsList[index % widget.newsList.length],

              widget.separator ??
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: context.insets.xl),
                    child: const TextWidget('•'),
                  ), // Optional separator
            ],
          );
        },
      ),
    );
  }
}
