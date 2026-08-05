import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

//TODO: fix and enhancement
const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuDividerHeight = 16;
const double _kMenuScreenPadding = 0;

abstract class PopupMenuEntry<T> extends StatefulWidget {
  const PopupMenuEntry({super.key});

  double get height;

  bool represents(T? value);
}

class PopupMenuDivider extends PopupMenuEntry<Never> {
  const PopupMenuDivider({super.key, this.height = _kMenuDividerHeight});

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<PopupMenuDivider> createState() => _PopupMenuDividerState();
}

class _PopupMenuDividerState extends State<PopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height);
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({required this.onLayout, required super.child});

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return child?.getDryLayout(constraints) ?? Size.zero;
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    return child?.getDryBaseline(constraints, baseline);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

class PopupMenuItemX<T> extends PopupMenuEntry<T> {
  const PopupMenuItemX({
    required this.child,
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.mouseCursor,
  });

  final T? value;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, PopupMenuItemX<T>> createState() =>
      PopupMenuItemState<T, PopupMenuItemX<T>>();
}

class PopupMenuItemState<T, W extends PopupMenuItemX<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    // Need to pop the navigator first in case onTap may push new route onto navigator.
    Navigator.pop<T>(context, widget.value);

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    final defaults = theme.useMaterial3
        ? _PopupMenuDefaultsM3(context)
        : _PopupMenuDefaultsM2(context);
    final states = <WidgetState>{if (!widget.enabled) WidgetState.disabled};

    var style = theme.useMaterial3
        ? (widget.labelTextStyle?.resolve(states) ??
              popupMenuTheme.labelTextStyle?.resolve(states)! ??
              defaults.labelTextStyle!.resolve(states)!)
        : (widget.textStyle ?? popupMenuTheme.textStyle ?? defaults.textStyle!);

    if (!widget.enabled && !theme.useMaterial3) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding:
            widget.padding ??
            (theme.useMaterial3
                ? _PopupMenuDefaultsM3.menuItemPadding
                : _PopupMenuDefaultsM2.menuItemPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(
            widget.mouseCursor,
            popupMenuTheme.mouseCursor,
          ),
          child: ListTileTheme.merge(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            child: item,
          ),
        ),
      ),
    );
  }
}

class CheckedPopupMenuItemX<T> extends PopupMenuItemX<T> {
  const CheckedPopupMenuItemX({
    super.key,
    super.value,
    this.checked = false,
    super.enabled,
    super.padding,
    super.height,
    super.labelTextStyle,
    super.mouseCursor,
    super.child,
    super.onTap,
  });

  final bool checked;

  @override
  PopupMenuItemState<T, CheckedPopupMenuItemX<T>> createState() =>
      _CheckedPopupMenuItemState<T>();
}

class _CheckedPopupMenuItemState<T>
    extends PopupMenuItemState<T, CheckedPopupMenuItemX<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;

  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _fadeDuration, vsync: this)
      ..value = widget.checked ? 1.0 : 0.0
      ..addListener(
        () => setState(() {
          /* animation changed */
        }),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void handleTap() {
    // This fades the checkmark in or out when tapped.
    if (widget.checked) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    super.handleTap();
  }

  @override
  Widget buildChild() {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    final defaults = theme.useMaterial3
        ? _PopupMenuDefaultsM3(context)
        : _PopupMenuDefaultsM2(context);
    final states = <WidgetState>{if (widget.checked) WidgetState.selected};
    final effectiveLabelTextStyle =
        widget.labelTextStyle ??
        popupMenuTheme.labelTextStyle ??
        defaults.labelTextStyle;
    return IgnorePointer(
      child: ListTileTheme.merge(
        contentPadding: EdgeInsets.zero,
        child: ListTile(
          enabled: widget.enabled,
          titleTextStyle: effectiveLabelTextStyle?.resolve(states),
          leading: FadeTransition(
            opacity: _opacity,
            child: Icon(
              _controller.isDismissed ? null : Icons.done,
              color: context.colors.onPrimary,
            ),
          ),
          title: widget.child,
        ),
      ),
    );
  }
}

class _PopupMenu<T> extends StatefulWidget {
  const _PopupMenu({
    required this.itemKeys,
    required this.route,
    required this.semanticLabel,
    required this.clipBehavior,
    super.key,
    this.constraints,
  });

  final List<GlobalKey> itemKeys;
  final _PopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final Clip clipBehavior;

  @override
  State<_PopupMenu<T>> createState() => _PopupMenuState<T>();
}

class _PopupMenuState<T> extends State<_PopupMenu<T>> {
  List<CurvedAnimation> _opacities = const <CurvedAnimation>[];

  @override
  void initState() {
    super.initState();
    _setOpacities();
  }

  @override
  void didUpdateWidget(covariant _PopupMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route.items.length != widget.route.items.length ||
        oldWidget.route.animation != widget.route.animation) {
      _setOpacities();
    }
  }

  void _setOpacities() {
    for (final opacity in _opacities) {
      opacity.dispose();
    }
    final newOpacities = <CurvedAnimation>[];
    final unit =
        1.0 /
        (widget.route.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    for (var i = 0; i < widget.route.items.length; i += 1) {
      final start = (i + 1) * unit;
      final end = clampDouble(start + 1.5 * unit, 0, 1);
      final opacity = CurvedAnimation(
        parent: widget.route.animation!,
        curve: Interval(start, end),
      );
      newOpacities.add(opacity);
    }
    _opacities = newOpacities;
  }

  @override
  void dispose() {
    for (final opacity in _opacities) {
      opacity.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit =
        1.0 /
        (widget.route.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final children = <Widget>[];
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    final defaults = theme.useMaterial3
        ? _PopupMenuDefaultsM3(context)
        : _PopupMenuDefaultsM2(context);

    for (var i = 0; i < widget.route.items.length; i += 1) {
      final opacity = _opacities[i];
      Widget item = widget.route.items[i];
      if (widget.route.initialValue != null &&
          widget.route.items[i].represents(widget.route.initialValue)) {
        item = item;
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            widget.route.itemSizes[i] = size;
          },
          child: FadeTransition(
            key: widget.itemKeys[i],
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final opacity = CurveTween(curve: const Interval(0, 1.0 / 3.0));
    final width = CurveTween(curve: Interval(0, unit));
    final height = CurveTween(
      curve: Interval(0, unit * widget.route.items.length),
    );

    final Widget child = Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      child: BlurWidget(
        child: ColoredBox(
          color: context.colors.primary,
          child: Container(
            decoration: BoxDecoration(gradient: context.gradients.button),
            child: SingleChildScrollView(
              padding:
                  widget.route.menuPadding ??
                  popupMenuTheme.menuPadding ??
                  defaults.menuPadding,
              child: ListBody(children: children),
            ),
          ),
        ),
      ),
    );
    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(widget.route.animation!),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: context.insets.xl,
              top: 30,
              end: context.insets.xl,
            ),
            child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                widthFactor: width.evaluate(widget.route.animation!),
                heightFactor: height.evaluate(widget.route.animation!),
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(
      constraints.biggest,
    ).deflate(const EdgeInsets.all(_kMenuScreenPadding) + padding);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final y = position.top;

    // Find the ideal horizontal position.
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      x = switch (textDirection) {
        TextDirection.rtl => size.width - position.right - childSize.width,
        TextDirection.ltr => position.left,
      };
    }
    final wantedPosition = Offset(x, y);
    final originCenter = position.toRect(Offset.zero & size).center;
    final subScreens = DisplayFeatureSubScreen.subScreensInBounds(
      Offset.zero & size,
      avoidBounds,
    );
    final subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    var x = wantedPosition.dx;
    var y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y =
          screen.bottom -
          childSize.height -
          _kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.position,
    required this.items,
    required this.itemKeys,
    required this.barrierLabel,
    required this.capturedThemes,
    required this.clipBehavior,
    this.initialValue,
    this.elevation,
    this.surfaceTintColor,
    this.shadowColor,
    this.semanticLabel,
    this.shape,
    this.menuPadding,
    this.color,
    this.constraints,
    super.settings,
    this.popUpAnimationStyle,
  }) : itemSizes = List<Size?>.filled(items.length, null),
       // Menus always cycle focus through their items irrespective of the
       // focus traversal edge behavior set in the Navigator.
       super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final RelativeRect position;
  final List<PopupMenuEntry<T>> items;
  final List<GlobalKey> itemKeys;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? menuPadding;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AnimationStyle? popUpAnimationStyle;

  CurvedAnimation? _animation;

  @override
  Animation<double> createAnimation() {
    if (popUpAnimationStyle != AnimationStyle.noAnimation) {
      return _animation ??= CurvedAnimation(
        parent: super.createAnimation(),
        curve: popUpAnimationStyle?.curve ?? Curves.linear,
        reverseCurve:
            popUpAnimationStyle?.reverseCurve ??
            const Interval(0, _kMenuCloseIntervalEnd),
      );
    }
    return super.createAnimation();
  }

  void scrollTo(int selectedItemIndex) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (itemKeys[selectedItemIndex].currentContext != null) {
        Scrollable.ensureVisible(itemKeys[selectedItemIndex].currentContext!);
      }
    });
  }

  @override
  Duration get transitionDuration =>
      popUpAnimationStyle?.duration ?? _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (
        var index = 0;
        selectedItemIndex == null && index < items.length;
        index += 1
      ) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }
    if (selectedItemIndex != null) {
      scrollTo(selectedItemIndex);
    }

    final Widget menu = _PopupMenu<T>(
      route: this,
      itemKeys: itemKeys,
      semanticLabel: semanticLabel,
      constraints: constraints,
      clipBehavior: clipBehavior,
    );
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }
}

Future<T?> showMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  String? semanticLabel,
  ShapeBorder? shape,
  EdgeInsetsGeometry? menuPadding,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  Clip clipBehavior = Clip.none,
  RouteSettings? routeSettings,
  AnimationStyle? popUpAnimationStyle,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final menuItemKeys = List<GlobalKey>.generate(
    items.length,
    (int index) => GlobalKey(),
  );
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(
    _PopupMenuRoute<T>(
      position: position,
      items: items,
      itemKeys: menuItemKeys,
      initialValue: initialValue,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).menuDismissLabel,
      shape: shape,
      menuPadding: menuPadding,
      color: color,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      constraints: constraints,
      clipBehavior: clipBehavior,
      settings: routeSettings,
      popUpAnimationStyle: popUpAnimationStyle,
    ),
  );
}

typedef PopupMenuCanceled = void Function();

typedef PopupMenuItemBuilder<T> =
    List<PopupMenuEntry<T>> Function(BuildContext context);

class PopupMenuButtonX<T> extends StatefulWidget {
  const PopupMenuButtonX({
    required this.itemBuilder,
    super.key,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8),
    this.menuPadding,
    this.child,
    this.splashRadius,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.iconColor,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.clipBehavior = Clip.none,
    this.useRootNavigator = false,
    this.popUpAnimationStyle,
    this.routeSettings,
    this.style,
  }) : assert(
         !(child != null && icon != null),
         'You can only pass [child] or [icon], not both.',
       );

  final PopupMenuItemBuilder<T> itemBuilder;

  final T? initialValue;

  final VoidCallback? onOpened;

  final PopupMenuItemSelected<T>? onSelected;

  final PopupMenuCanceled? onCanceled;

  final String? tooltip;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry? menuPadding;

  final double? splashRadius;

  final Widget? child;

  final Widget? icon;

  final Offset offset;

  final bool enabled;

  final ShapeBorder? shape;

  final Color? color;

  final Color? iconColor;

  final bool? enableFeedback;

  final double? iconSize;

  final BoxConstraints? constraints;

  final PopupMenuPosition? position;

  final Clip clipBehavior;

  final bool useRootNavigator;

  final AnimationStyle? popUpAnimationStyle;

  final RouteSettings? routeSettings;

  final ButtonStyle? style;

  @override
  PopupMenuButtonXState<T> createState() => PopupMenuButtonXState<T>();
}

class PopupMenuButtonXState<T> extends State<PopupMenuButtonX<T>> {
  void showButtonMenu() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(
              context,
              rootNavigator: widget.useRootNavigator,
            ).overlay!.context.findRenderObject()!
            as RenderBox;
    final popupMenuPosition =
        widget.position ?? popupMenuTheme.position ?? PopupMenuPosition.over;
    late Offset offset;
    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        offset = widget.offset;
      case PopupMenuPosition.under:
        offset = Offset(0, button.size.height) + widget.offset;
        if (widget.child == null) {
          // Remove the padding of the icon button.
          offset -= Offset(0, widget.padding.vertical / 2);
        }
    }
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    final items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      widget.onOpened?.call();
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        surfaceTintColor:
            widget.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        menuPadding: widget.menuPadding ?? popupMenuTheme.menuPadding,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        clipBehavior: widget.clipBehavior,
        useRootNavigator: widget.useRootNavigator,
        popUpAnimationStyle: widget.popUpAnimationStyle,
        routeSettings: widget.routeSettings,
      ).then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool get _canRequestFocus {
    final mode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    return switch (mode) {
      NavigationMode.traditional => widget.enabled,
      NavigationMode.directional => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    final enableFeedback =
        widget.enableFeedback ??
        PopupMenuTheme.of(context).enableFeedback ??
        true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.child != null) {
      return Tooltip(
        message:
            widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          onTap: widget.enabled ? showButtonMenu : null,
          canRequestFocus: _canRequestFocus,
          radius: widget.splashRadius,
          enableFeedback: enableFeedback,
          child: widget.child,
        ),
      );
    }

    return IconButton(
      icon: widget.icon ?? Icon(Icons.adaptive.more),
      padding: widget.padding,
      splashRadius: widget.splashRadius,
      iconSize: widget.iconSize ?? popupMenuTheme.iconSize ?? iconTheme.size,
      color: widget.iconColor ?? popupMenuTheme.iconColor ?? iconTheme.color,
      tooltip:
          widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: widget.enabled ? showButtonMenu : null,
      enableFeedback: enableFeedback,
      style: widget.style,
    );
  }
}

class _EffectiveMouseCursor extends WidgetStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final WidgetStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<WidgetState> states) {
    return WidgetStateProperty.resolveAs<MouseCursor?>(widgetCursor, states) ??
        themeCursor?.resolve(states) ??
        WidgetStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => 'MaterialStateMouseCursor(PopupMenuItemState)';
}

class _PopupMenuDefaultsM2 extends PopupMenuThemeData {
  _PopupMenuDefaultsM2(this.context) : super(elevation: 8);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  TextStyle? get textStyle => _textTheme.titleMedium;

  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8);

  static EdgeInsets menuItemPadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
}

class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context) : super(elevation: 3);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      // TODO(quncheng): Update this hard-coded value to use the latest tokens.
      final style = _textTheme.labelLarge!;
      if (states.contains(WidgetState.disabled)) {
        return style.apply(color: _colors.onSurface.withOpacity(0.38));
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surfaceContainer;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  // TODO(bleroux): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8);

  // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  static EdgeInsets menuItemPadding = const EdgeInsets.symmetric(
    horizontal: 12,
  );
}
