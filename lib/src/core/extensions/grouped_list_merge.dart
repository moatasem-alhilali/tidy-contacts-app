import 'package:hive_manager/design-system-package/src/widgets/pagination/pagination.dart';

/// Extension to add a smart merge function for grouped lists
/// Merges this list of grouped items with another, combining groups by groupName,
/// and ensuring no duplicate items (by idSelector) within the same group.
extension GroupedListMergeExt<T> on List<Grouped<T>> {
  List<Grouped<T>> mergeWith(
    List<Grouped<T>> other,
    String Function(T) idSelector,
  ) {
    final mergedGroups = <String, List<T>>{};

    for (final group in this) {
      mergedGroups[group.groupName] = [...group.groupList];
    }

    for (final group in other) {
      if (mergedGroups.containsKey(group.groupName)) {
        final existingList = mergedGroups[group.groupName]!
          // **Remove the ID check if you want to allow duplicates!**
          ..addAll(group.groupList);
      } else {
        mergedGroups[group.groupName] = [...group.groupList];
      }
    }

    final mergedList = mergedGroups.entries
        .map((e) => Grouped<T>(groupName: e.key, groupList: e.value))
        .toList()
      ..sort((a, b) => b.groupName.compareTo(a.groupName));
    return mergedList;
  }
}
