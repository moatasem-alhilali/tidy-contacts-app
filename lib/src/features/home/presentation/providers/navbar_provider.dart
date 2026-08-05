import 'package:flutter_riverpod/legacy.dart';

class NavbarState {
  const NavbarState({
    this.selectedIndex = 0,
    this.isSheetExpanded = false,
    this.expandedNodeIds = const {},
    this.selectedLeafId,
  });
  final int selectedIndex;
  final bool isSheetExpanded;
  final Set<String> expandedNodeIds;
  final String? selectedLeafId;

  NavbarState copyWith({
    int? selectedIndex,
    bool? isSheetExpanded,
    Set<String>? expandedNodeIds,
    String? selectedLeafId,
  }) {
    return NavbarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSheetExpanded: isSheetExpanded ?? this.isSheetExpanded,
      expandedNodeIds: expandedNodeIds ?? this.expandedNodeIds,
      selectedLeafId: selectedLeafId ?? this.selectedLeafId,
    );
  }
}

class NavbarNotifier extends StateNotifier<NavbarState> {
  NavbarNotifier() : super(const NavbarState());

  void selectTab(int index) {
    if (state.selectedIndex != index) {
      state = state.copyWith(selectedIndex: index);
    }
    // Depending on requirements, we might want to automatically open the sheet
    // if the tab corresponds to a category with children.
    // For now, we leave it to manual toggle or UI logic.
  }

  void toggleSheet() {
    state = state.copyWith(isSheetExpanded: !state.isSheetExpanded);
  }

  void setSheetExpanded(bool isExpanded) {
    if (state.isSheetExpanded != isExpanded) {
      state = state.copyWith(isSheetExpanded: isExpanded);
    }
  }

  void toggleNode(String nodeId) {
    final newSet = Set<String>.from(state.expandedNodeIds);
    if (newSet.contains(nodeId)) {
      newSet.remove(nodeId);
    } else {
      newSet.add(nodeId);
    }
    state = state.copyWith(expandedNodeIds: newSet);
  }

  void openNode(String nodeId) {
    if (!state.expandedNodeIds.contains(nodeId)) {
      final newSet = Set<String>.from(state.expandedNodeIds)..add(nodeId);
      state = state.copyWith(expandedNodeIds: newSet);
    }
  }

  void selectLeaf(String leafId) {
    state = state.copyWith(selectedLeafId: leafId);
  }
}

final navbarProvider = StateNotifierProvider<NavbarNotifier, NavbarState>((
  ref,
) {
  return NavbarNotifier();
});
