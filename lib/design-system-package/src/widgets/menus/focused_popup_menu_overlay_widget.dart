part of 'menus.dart';

class FocusedPopupMenuEntity<T> {
  FocusedPopupMenuEntity({
    required this.id,
    required this.label,
  });

  final T id;
  final String label;
}

class FocusedPopupMenuOverlayWidget<T> extends StatefulWidget {
  const FocusedPopupMenuOverlayWidget({
    required this.items,
    required this.selectedId,
    super.key,
    this.onSelected,
    this.builder,
  });

  final List<FocusedPopupMenuEntity<T>> items;
  final T selectedId;
  final ValueChanged<FocusedPopupMenuEntity<T>>? onSelected;
  final Widget Function(FocusedPopupMenuEntity<T>? selected)? builder;

  @override
  State<FocusedPopupMenuOverlayWidget<T>> createState() =>
      _FocusedPopupMenuState<T>();
}

class _FocusedPopupMenuState<T> extends State<FocusedPopupMenuOverlayWidget<T>>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late FocusedPopupMenuEntity<T> selected;

  late AnimationController _fadeController;
  late CurvedAnimation _scaleAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    selected = widget.items.firstWhere(
      (i) => i.id == widget.selectedId,
      orElse: () => widget.items.first,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Close if not current screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ModalRoute.of(context)!.isCurrent) {
        _removeOverlay(immediate: true);
      }
    });
  }

  void _showMenuBelowButton() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonSize = renderBox.size;
    final buttonOffset = renderBox.localToGlobal(Offset.zero);

    const menuWidth = 220.0;
    final dx = buttonOffset.dx + buttonSize.width / 2 - menuWidth / 2;
    final dy = buttonOffset.dy + buttonSize.height + 6;

    _showMenuAtOffset(dx, dy);
  }

  void _showMenuAtOffset(double dx, double dy) {
    final overlay = Overlay.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    const menuWidth = 220.0;

    double? left;
    double? right;

    if (dx < screenWidth * 0.3) {
      left = dx;
    } else if (dx > screenWidth * 0.7) {
      right = screenWidth - dx;
    } else {
      left = dx - menuWidth / 2;
    }

    if (left != null && left + menuWidth > screenWidth) {
      left = screenWidth - menuWidth - 8;
    }
    if (left != null && left < 8) {
      left = 8;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            Positioned(
              left: left,
              right: right,
              top: dy,
              child: FadeTransition(
                opacity: _fadeController,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildMenuWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    _fadeController.forward();
  }

  void _removeOverlay({bool immediate = false}) {
    if (_overlayEntry == null) return;

    if (immediate) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _fadeController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  Widget _buildMenuWidget() {
    return Material(
      borderRadius: BorderRadius.all(context.corners.rc),
      elevation: 2,
      color: context.colors.primary,
      child: Container(
        width: 242.h,
        padding: EdgeInsets.symmetric(vertical: context.spaces.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.items.map((item) {
            final isSelected = item.id == selected.id;
            return InkWell(
              onTap: () async {
                setState(() => selected = item);
                widget.onSelected?.call(item);
                await Future<void>.delayed(const Duration(milliseconds: 100));
                _removeOverlay();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.spaces.md,
                  horizontal: context.spaces.md,
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check : null,
                      size: 20.h,
                      color: isSelected
                          ? context.colors.onPrimary
                          : Colors.transparent,
                    ),
                    SizedBox(width: context.spaces.sm),
                    Expanded(
                      child: TextWidget(
                        item.label,
                        style: context.textStyles.titleMedium.copyWith(
                          color: context.colors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: _showMenuBelowButton,
      child: widget.builder?.call(selected) ??
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spaces.md,
              vertical: context.spaces.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(context.corners.rb),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selected.label),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
    );
  }
}
