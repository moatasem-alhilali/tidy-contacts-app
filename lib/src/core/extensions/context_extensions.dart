part of 'extensions.dart';

extension AutoRouteExtensions on BuildContext {
  void pushAndRemoveAll(PageRouteInfo route) {
    pushAndRemove(route);
  }

  void pushAndRemove(PageRouteInfo route, {String? routeName}) {
    router.pushAndPopUntil(
      route,
      predicate: (route) =>
          routeName == null ? false : route.settings.name == routeName,
    );
  }

  void popUntilRouteName(String name) => router.popUntilRouteWithName(name);

  Future<T?> pushX<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) async {
    return router.push(
      route,
      onFailure: onFailure,
    );
  }

  Future<T?> pushXName<T extends Object?>(
    String route, {
    OnNavigationFailure? onFailure,
  }) async {
    return router.pushPath(
      route,
      onFailure: onFailure,
    );
  }

  void replaceX(PageRouteInfo route) {
    router.replace(
      route,
    );
  }

  void popAndPushX(PageRouteInfo route) {
    router.popAndPush(
      route,
    );
  }

  bool get canPop => router.canPop();

  void safeReplaceX(PageRouteInfo route, {bool useSchedulerBinding = true}) {
    if (useSchedulerBinding == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        router.replace(route);
      });
    } else {
      router.replace(route);
    }
  }

  void safePushX(PageRouteInfo route, {bool useSchedulerBinding = true}) {
    if (useSchedulerBinding == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        router.push(route);
      });
    } else {
      router.push(route);
    }
  }

  // safe push path

  void safePushPathX(String path) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      router.pushPath(path);
    });
  }

  void popX<T extends Object?>([T? result]) {
    router.pop<T>(result);
  }

  void maybePopTopX() => router.maybePopTop();

  Future<void> navigateToX(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) =>
      RouterScope.of(this).controller.navigate(
            route,
            onFailure: onFailure,
          );

  // navigateToX
  Future<void> navigateToXPath(
    String path, {
    OnNavigationFailure? onFailure,
  }) =>
      RouterScope.of(this).controller.navigatePath(
            path,
            onFailure: onFailure,
            includePrefixMatches: true,
          );

  // ny path
  void pushPathX(String path) {
    router.pushPath(path);
  }

  void replacePathX(String path) {
    router.replacePath(path);
  }

  void pushAllX(List<PageRouteInfo> routes) {
    router.pushAll(routes);
  }

  void replaceAllX(List<PageRouteInfo> routes) {
    router.replaceAll(routes);
  }

  //current path
  String get currentPath {
    final route = AutoRouter.of(this).currentPath;
    return route;
  }

  String get currentRouteName {
    final route = AutoRouter.of(this).current.name;
    return route;
  }
}
