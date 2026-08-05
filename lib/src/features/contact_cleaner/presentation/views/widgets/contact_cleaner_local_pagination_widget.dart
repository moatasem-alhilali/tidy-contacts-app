// Local (in-memory) pagination list.
// Self-contained: a ListView with a header, incremental "load more" via
// AdaptiveButton, and an adaptive empty state — no design-system dependency.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/generated/codegen_loader.g.dart';
import 'package:hive_manager/src/features/contact_cleaner/presentation/views/widgets/contact_cleaner_common_widgets.dart';

class ContactCleanerLocalPaginationWidget<T> extends StatefulWidget {
  const ContactCleanerLocalPaginationWidget({
    required this.items,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.emptyWidget,
    required this.paginationIdentity,
    super.key,
    this.pageSize = 25,
    this.separatorWidget,
  });

  final List<T> items;
  final Widget Function(BuildContext context, int visibleCount, int totalCount)
  headerBuilder;
  final Widget Function(T item) itemBuilder;
  final Widget emptyWidget;
  final Object? paginationIdentity;
  final int pageSize;
  final Widget? separatorWidget;

  @override
  State<ContactCleanerLocalPaginationWidget<T>> createState() =>
      _ContactCleanerLocalPaginationWidgetState<T>();
}

class _ContactCleanerLocalPaginationWidgetState<T>
    extends State<ContactCleanerLocalPaginationWidget<T>> {
  int _currentPage = 1;

  @override
  void didUpdateWidget(ContactCleanerLocalPaginationWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.paginationIdentity != oldWidget.paginationIdentity ||
        widget.items.length != oldWidget.items.length ||
        !listEquals(widget.items, oldWidget.items)) {
      _currentPage = 1;
    }
  }

  int get _visibleCount =>
      (_currentPage * widget.pageSize).clamp(0, widget.items.length);

  bool get _hasMore => _visibleCount < widget.items.length;

  @override
  Widget build(BuildContext context) {
    final List<T> visible = widget.items.take(_visibleCount).toList();
    final Widget separator =
        widget.separatorWidget ?? const SizedBox(height: kGapSm);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: kGapXl),
      children: [
        widget.headerBuilder(context, visible.length, widget.items.length),
        const SizedBox(height: kGapMd),
        if (widget.items.isEmpty)
          widget.emptyWidget
        else ...[
          for (int i = 0; i < visible.length; i++) ...[
            if (i > 0) separator,
            widget.itemBuilder(visible[i]),
          ],
          if (_hasMore) ...[
            const SizedBox(height: kGapLg),
            Center(
              child: AdaptiveButton(
                onPressed: () => setState(() => _currentPage += 1),
                style: AdaptiveButtonStyle.tinted,
                label: LocaleKeys.contact_cleaner_load_more.tr(),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
