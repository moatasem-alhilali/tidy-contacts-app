import 'package:auto_route/auto_route.dart';

extension TabsRouterExtension on TabsRouter {
  /// Find the index of a route in the tabs based on route path
  int findIndexByPath(String path) {
    // Get the last segment from the path
    var targetSegment = path.split('/').last.toLowerCase();

    targetSegment = targetSegment.replaceAll('-', '');
    for (var i = 0; i < pageCount; i++) {
      final routeName = stack[i].name?.toLowerCase() ?? '';

      // Check if route name contains the target segment
      if (routeName.contains(targetSegment)) {
        return i;
      }

      // Also check for special cases
      if (targetSegment == 'home' && routeName.contains('dashboard')) {
        return i;
      }
    }
    return -1;
  }

  /// Find the index of a route in the tabs based on route name
  int findIndexByName(String name) {
    for (var i = 0; i < pageCount; i++) {
      final route = stack[i].name ?? '';
      if (route.toLowerCase().contains(name.toLowerCase())) {
        return i;
      }
    }
    return -1;
  }

  /// Navigate to a route based on route path
  void navigateByPath(String path) {
    final index = findIndexByPath(path);
    if (index != -1) {
      setActiveIndex(index);
    }
  }

  /// Navigate to a route based on route name
  void navigateByName(String name) {
    final index = findIndexByName(name);
    if (index != -1) {
      setActiveIndex(index);
    }
  }
}
