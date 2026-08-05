// ignore_for_file: omit_local_variable_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

class ContactCleanerLocalPaginationWidget<T> extends ConsumerStatefulWidget {
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
  ConsumerState<ContactCleanerLocalPaginationWidget<T>> createState() =>
      _ContactCleanerLocalPaginationWidgetState<T>();
}

class _ContactCleanerLocalPaginationWidgetState<T>
    extends ConsumerState<ContactCleanerLocalPaginationWidget<T>> {
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

  int get _totalPages {
    if (widget.items.isEmpty) {
      return 1;
    }
    return (widget.items.length / widget.pageSize).ceil();
  }

  List<T> get _visibleItems {
    final visibleCount = (_currentPage * widget.pageSize).clamp(
      0,
      widget.items.length,
    );
    return widget.items.take(visibleCount).toList();
  }

  Future<void> _loadMore() async {
    if (_currentPage >= _totalPages) {
      return;
    }
    setState(() {
      _currentPage += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _visibleItems;
    final pagination = ApiPaginatedBaseResponse<T>(
      data: visibleItems,
      currentPage: _currentPage,
      totalPages: _totalPages,
      totalCount: widget.items.length,
    );

    return ListViewSeparatedScrollPaginationWithHeaderScroll<T>(
      onLoading: _loadMore,
      pagination: pagination,
      builder: widget.itemBuilder,
      header: widget.headerBuilder(
        context,
        visibleItems.length,
        widget.items.length,
      ),
      isError: false,
      isLoading: false,
      emptyWidget: widget.emptyWidget,
      errorWidget: widget.emptyWidget,
      loadingWidget: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.insets.xl.h),
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      ),
      separatorWidget:
          widget.separatorWidget ?? SizedBox(height: context.insets.sm.h),
    );
  }
}
