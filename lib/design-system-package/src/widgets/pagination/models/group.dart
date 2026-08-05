part of '../pagination.dart';

class Grouped<T> {
  Grouped({required this.groupName, required this.groupList});

  final String groupName;
  final List<T> groupList;
  Grouped<E> mapItems<E>(E Function(T) mapper) {
    return Grouped<E>(
      groupName: groupName,
      groupList: groupList.map(mapper).toList(),
    );
  }
}
